
import logging
import azure.functions as func
import os
import json
from azure.ai.agents import AgentsClient
from azure.ai.agents.models import MessageRole, BingGroundingTool
from azure.identity import DefaultAzureCredential

# 環境変数から値を取得
project_endpoint = os.getenv("PROJECT_ENDPOINT")
azure_bing_connection_id = os.getenv("AZURE_BING_CONNECTION_ID")
model_deployment_name = os.getenv("MODEL_DEPLOYMENT_NAME")
managed_identity_client_id = os.getenv("AZURE_CLIENT_ID")

if not all([project_endpoint, azure_bing_connection_id, model_deployment_name, managed_identity_client_id]):
    raise ValueError("環境変数が正しく設定されていません。")

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

tool_properties_json = json.dumps([{"propertyName": "search_query", "propertyType": "string", "description": "指定されたキーワードを使用してBing検索を実行し、関連情報を取得します。"}])

@app.generic_trigger(
    arg_name="context",
    type="mcpToolTrigger",
    toolName="bingsearch_mcp",
    description="指定されたキーワードを使用してBing検索を実行し、関連情報を取得します。",
    toolProperties=tool_properties_json,
)

def bingsearch_mcp(context) -> str:
    context_json = json.loads(context)
    search_query = context_json['arguments'].get('search_query')

    # Ensure the Azure Function has the necessary permissions in Azure AD
    # Assign a managed identity to the Azure Function and grant it the required roles (e.g., Cognitive Services User role)
    # Then, use DefaultAzureCredential to authenticate

    agents_client = AgentsClient(
        endpoint=project_endpoint,
        credential=DefaultAzureCredential(managed_identity_client_id=managed_identity_client_id),
    )


    # [START create_agent_with_bing_grounding_tool]
    # Initialize agent bing tool and add the connection id
    bing = BingGroundingTool(connection_id=azure_bing_connection_id)
    
    # Create agent with the bing tool and process agent run
    with agents_client:
        agent = agents_client.create_agent(
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
        # [END create_agent_with_bing_grounding_tool]

        print(f"Created agent, ID: {agent.id}")

        # Create thread for communication
        thread = agents_client.threads.create()
        print(f"Created thread, ID: {thread.id}")

        # Create message to thread
        message = agents_client.messages.create(
            thread_id=thread.id,
            role=MessageRole.USER,
            content=search_query,
        )
        print(f"Created message, ID: {message.id}")

        # Create and process agent run in thread with tools
        run = agents_client.runs.create_and_process(thread_id=thread.id, agent_id=agent.id)
        print(f"Run finished with status: {run.status}")

        if run.status == "failed":
            print(f"Run failed: {run.last_error}")

        # Fetch run steps to get the details of the agent run
        # run_steps = agents_client.run_steps.list(thread_id=thread.id, run_id=run.id)
        # for step in run_steps:
        #     print(f"Step {step['id']} status: {step['status']}")
        #     step_details = step.get("step_details", {})
        #     tool_calls = step_details.get("tool_calls", [])

        #     if tool_calls:
        #         print("  Tool calls:")
        #         for call in tool_calls:
        #             print(f"    Tool Call ID: {call.get('id')}")
        #             print(f"    Type: {call.get('type')}")

        #             bing_grounding_details = call.get("bing_grounding", {})
        #             if bing_grounding_details:
        #                 print(f"    Bing Grounding ID: {bing_grounding_details.get('requesturl')}")

        #     print()  # add an extra newline between steps

        # Delete the agent when done
        agents_client.delete_agent(agent.id)
        print("Deleted agent")

        # Print the Agent's response message with optional citation
        response_message = agents_client.messages.get_last_message_by_role(thread_id=thread.id, role=MessageRole.AGENT)
        #return response_message.text_messages[0].text.value
        #test
        return response_message.text_messages[0].text.value
