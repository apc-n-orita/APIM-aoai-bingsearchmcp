# Declare output values for the main terraform module.
#
# This allows the main terraform module outputs to be referenced by other modules,
# or by the local machine as a way to reference created resources in Azure for local development.
# Secrets should not be added here.
#
# Outputs are automatically saved in the local azd environment .env file.
# To see these outputs, run `azd env get-values`. `azd env get-values --output json` for json output.

output "AZURE_LOCATION" {
  value = var.location
}

output "AZURE_TENANT_ID" {
  value = data.azurerm_client_config.current.tenant_id
}

output "SERVICE_AOAI_ENDPOINTS" {
  value = "${module.apim.gateway_url}/openai/deployments/${var.openai.model.model}_${var.openai.model.version}/chat/completions?api-version={api-version}"
}

output "SERVICE_AOAI_ENDPOINTS_SUBSCRIPTIONKEY" {
  value     = azurerm_api_management_subscription.sa_ai_api.primary_key
  sensitive = true
}

output "SERVICE_BINGSEARCHMCP_ENDPOINTS" {
  value = "${module.apim.gateway_url}/${lower(module.funcmcp_api.api_name)}/sse"
}

output "SERVICE_BINGSEARCHMCP_ENDPOINTS_SUBSCRIPTIONKEY" {
  value     = "azurerm_api_management_subscription.sa_ai_api.primary_key"
  sensitive = true
}

output "SERVICE_OAUTH_BINGSEARCHMCP_ENDPOINTS" {
  value = "${module.apim.gateway_url}/${lower(module.funcmcp_oauth_api.api_name)}/sse"
}

output "GRAFANA_WORKSPACE_NAME" {
  value = lower("graf-${var.environment_name}-${substr(local.resource_token, 0, 3)}")
}
