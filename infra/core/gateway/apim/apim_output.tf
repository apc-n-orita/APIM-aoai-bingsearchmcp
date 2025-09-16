output "APIM_SERVICE_NAME" {
  value = azurerm_api_management.apim.name
}

output "API_MANAGEMENT_LOGGER_ID" {
  value = azapi_resource.apim_logger.id
}

output "gateway_url" {
  value = azurerm_api_management.apim.gateway_url
}
