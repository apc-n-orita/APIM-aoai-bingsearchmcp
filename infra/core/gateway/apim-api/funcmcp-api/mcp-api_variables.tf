variable "resource_group_name" {}
variable "apim_service_name" {
  type        = string
  description = "The name of the API Management service"
}

variable "function_app_name" {
  type        = string
  description = "The name of the Function App hosting the MCP endpoints"
}

variable "func_url" {
  type        = string
  description = "The URL of the Function App"
}

variable "product_id" {
  type        = string
  description = "The ID of the product to which the API belongs"
}

variable "api_name" {
  type        = string
  description = "The name of the API to be created in APIM."
}

variable "api_management_logger_id" {
  type        = string
  description = "The resource ID of the Application Insights logger for APIM diagnostics."
}

variable "masterkey" {
  type        = string
  description = "The master key for the Function App."
}
