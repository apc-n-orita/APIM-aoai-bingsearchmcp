output "oauth_api_id" {
  value = azurerm_api_management_api.oauth.id
}

output "api_name" {
  value = azurerm_api_management_api.oauth.name
}

output "entra_app_id" {
  value = azuread_application.entra_app.client_id
}

output "entra_app_tenant_id" {
  value = var.entra_app_tenant_id
}

