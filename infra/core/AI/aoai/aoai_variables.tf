variable "openai_locations" {
  description = "List of locations for each OpenAI account"
  type        = list(string)
}

variable "openai_model" {
  description = "Model configuration for OpenAI deployment"
  type = object({
    model      = string
    version    = string
    deploytype = string
    capacity   = number
  })
}

variable "resource_group_name" {
  type = string
}

variable "name" {
  description = "Base name for resources"
  type        = string
}

#variable "content_filters" {
#  type = list(object({
#    severityThreshold = optional(string)
#    blocking          = bool
#    enabled           = bool
#    name              = string
#    source            = string
#  }))
#  description = "RAIポリシーに適用するコンテンツフィルターの一覧"
#}

variable "log_analytics_workspace_id" {
  description = "共通で使用する Log Analytics Workspace のリソース ID"
  type        = string
}

variable "azurerm_user_assigned_identity_id" {
  description = "The User Assigned Identity Resource ID to be associated with the APIM instance"
  type        = string
  default     = ""
}

variable "identity_type" {
  description = "The type of Managed Identity used for the APIM instance. Possible values are: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None"
  type        = string
  default     = "SystemAssigned"
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned", "None"], var.identity_type)
    error_message = "Allowed values for identity_type are: 'SystemAssigned, UserAssigned', SystemAssigned, UserAssigned, None"
  }
}
