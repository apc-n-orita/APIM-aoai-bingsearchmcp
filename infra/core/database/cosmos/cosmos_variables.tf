
variable "sql_account_name" {
  description = "Cosmos DB SQL API account name (unique globally). 指定なければ命名接頭辞 + 'sql' を推奨"
  type        = string
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "api_management_name" {
  description = "API Management service name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "tags" {
  description = "Tags map"
  type        = map(string)
  default     = {}
}

variable "database_name" {
  description = "Cosmos SQL database name"
  type        = string
}

variable "container_name" {
  description = "Cosmos SQL container name"
  type        = string
  default     = "clientregistrations"
}

variable "public_network_access_enabled" {
  description = "Enable public network access to Cosmos DB account"
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID"
  type        = string
}
