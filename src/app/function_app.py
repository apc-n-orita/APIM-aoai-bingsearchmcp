import logging
import azure.functions as func
import os
import json
import re
from azure.ai.projects import AIProjectClient
from azure.ai.agents.models import MessageRole, BingGroundingTool
from azure.identity import DefaultAzureCredential
from azure.monitor.opentelemetry import configure_azure_monitor
from opentelemetry import trace
from opentelemetry.trace import SpanKind, Status, StatusCode
from azure.core.settings import settings
from azure.ai.projects.models import EvaluatorIds

settings.tracing_implementation = "opentelemetry"

# 環境変数から値を取得
project_endpoint = os.getenv("PROJECT_ENDPOINT")
azure_bing_connection_id = os.getenv("AZURE_BING_CONNECTION_ID")
model_deployment_name = os.getenv("MODEL_DEPLOYMENT_NAME")
managed_identity_client_id = os.getenv("AZURE_CLIENT_ID")

if not all([project_endpoint, azure_bing_connection_id, model_deployment_name, managed_identity_client_id]):
    raise ValueError("環境変数が正しく設定されていません。")

# --- AI Foundry Trace & Agent Setup ---
try:
    # AIProjectClient を使用して接続文字列を取得
    project_client = AIProjectClient(
        credential=DefaultAzureCredential(managed_identity_client_id=managed_identity_client_id),
        endpoint=project_endpoint,
    )
    connection_string = project_client.telemetry.get_application_insights_connection_string()

    # Azure Monitor トレースを設定
    configure_azure_monitor(connection_string=connection_string)
    tracer = trace.get_tracer(__name__)
    # トレーサーの取得
    logging.info("Application Insights 設定が有効化されました")
except Exception as e:
    logging.warning(f"Application Insights の設定に失敗しました: {e}. トレースは無効です")
    raise ValueError("Application Insights の設定に失敗しました")

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)
tool_properties_json = json.dumps([
    {
        "propertyName": "search_query",
        "propertyType": "string",
        "description": "指定されたキーワードを使用してBing検索を実行し、関連情報を取得します。"
    }
])

@app.generic_trigger(
    arg_name="context",
    type="mcpToolTrigger",
    toolName="bingsearch_mcp",
    description="指定されたキーワードを使用してBing検索を実行し、関連情報を取得します。",
    toolProperties=tool_properties_json,
)
def bingsearch_mcp(context) -> str:
    """Bing検索を実行してWeb情報を取得する"""
    context_json = json.loads(context)
    search_query = context_json['arguments'].get('search_query')
    safe_query = re.sub(r"\s+", "_", str(search_query))[:10].rstrip("_")

    with tracer.start_as_current_span(f"invoke_agent_bingsearch:{safe_query}") as span:
        try:
            span.set_attribute("search.query", search_query)
            span.set_attribute("search.engine", "bing")
            logging.info(f"検索クエリ: {search_query}")


            bing = BingGroundingTool(connection_id=azure_bing_connection_id)

            agent = project_client.agents.create_agent(
                model=model_deployment_name,
                name="bingsearch-agent",
                instructions="""
                    You are a web search agent.
                    Your only tool is search_tool - use it to find information.
                    You make only one search call at a time.
                    Once you have the results, you never do calculations based on them.
                """,
                headers={"x-ms-enable-preview": "true"},
                tools=bing.definitions,
            )
            span.set_attribute("agent.id", agent.id)
            print(f"Created agent, ID: {agent.id}")

            thread = project_client.agents.threads.create()
            span.set_attribute("thread.id", thread.id)
            print(f"Created thread, ID: {thread.id}")

            message = project_client.agents.messages.create(
                thread_id=thread.id,
                role=MessageRole.USER,
                content=search_query,
            )
            span.set_attribute("message.id", message.id)
            print(f"Created message, ID: {message.id}")

            run = project_client.agents.runs.create_and_process(thread_id=thread.id, agent_id=agent.id)
            span.set_attribute("run.id", run.id)
            span.set_attribute("run.status", run.status)
            print(f"Run finished with status: {run.status}")

            if run.status == "failed":
                span.set_attribute("run.error", str(run.last_error))
                print(f"Run failed: {run.last_error}")
                project_client.agents.delete_agent(agent.id)
                print("Deleted agent")
                raise RuntimeError(f"Agent run failed: {run.last_error}")

            # --- 継続的評価の設定（msdocs準拠） ---
            evaluators = {
                "Relevance": {"Id": EvaluatorIds.Relevance.value},
                "Fluency": {"Id": EvaluatorIds.Fluency.value},
                "Coherence": {"Id": EvaluatorIds.Coherence.value},
                # セキュリティ・リスク系評価指標
                "Violence": {"Id": EvaluatorIds.Violence.value},
                "Sexual": {"Id": EvaluatorIds.Sexual.value},
                "SelfHarm": {"Id": EvaluatorIds.Self_Harm.value},
                "HateUnfairness": {"Id": EvaluatorIds.Hate_Unfairness.value},
                "IndirectAttack": {"Id": EvaluatorIds.Indirect_Attack.value},
                "ProtectedMaterial": {"Id": EvaluatorIds.Protected_Material.value},
                "ContentSafety": {"Id": EvaluatorIds.Content_Safety.value},
                "CodeVulnerability": {"Id": EvaluatorIds.Code_Vulnerability.value},
            }
            app_insights_connection_string = project_client.telemetry.get_application_insights_connection_string()
            # 評価指標名とIDをspan属性に記録
            for eval_name, eval_info in evaluators.items():
                span.set_attribute(f"evaluation.{eval_name}.id", eval_info["Id"])
            try:
                project_client.evaluations.create_agent_evaluation(
                    AgentEvaluationRequest(
                        thread_id=thread.id,
                        run_id=run.id,
                        evaluators=evaluators,
                        app_insights_connection_string=app_insights_connection_string,
                    )
                )
                span.set_attribute("evaluation.request.success", True)
                logging.info("AIエージェントの継続的評価リクエストを送信しました")
            except Exception as eval_inner_e:
                span.set_attribute("evaluation.request.success", False)
                span.set_attribute("evaluation.request.error", str(eval_inner_e))
                logging.warning(f"継続的評価リクエストに失敗しました: {eval_inner_e}")    

            project_client.agents.delete_agent(agent.id)
            print("Deleted agent")

            response_message = project_client.agents.messages.get_last_message_by_role(
                thread_id=thread.id,
                role=MessageRole.AGENT
            )
            response_text = response_message.text_messages[0].text.value
            span.set_attribute("response.length", len(response_text))
            span.set_attribute("search.success", True)

        except (Exception, RuntimeError) as e:
            span.set_status(Status(StatusCode.ERROR, str(e)))
            span.record_exception(e)
            span.set_attribute("search.success", False)
            span.set_attribute("error.type", type(e).__name__)
            span.set_attribute("error.message", str(e))
            logging.error(f"検索処理中にエラーが発生しました: {e}")
            raise

    return response_text
