variable "resource_group_name" {}
variable "apim_service_name" {
  type        = string
  description = "The name of the API Management service"
}

variable "api_management_logger_id" {
  type        = string
  description = "The resource ID of the Application Insights logger for APIM diagnostics."
}

variable "entra_app_tenant_id" {
  type        = string
  description = "The Entra application's tenant ID (entraApp.outputs.entraAppTenantId)"
}

variable "entra_app_uami_client_id" {
  type        = string
  description = "The client ID of the user-assigned managed identity for Entra app."
}

variable "entra_app_display_name" {
  type        = string
  description = "The display name of the Entra application."
}

variable "entra_app_uami_principal_id" {
  type        = string
  description = "The principal ID of the user-assigned managed identity."
}

variable "azureuser_object_id" {
  type        = string
  description = "The object ID of the Azure user."
}
