variable "name" {
  description = "The name of the AI service."
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}


variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "ai_model" {
  description = "AI model deployment configuration."
  type = object({
    model      = string
    version    = string
    format     = string
    deploytype = string
    capacity   = number
  })
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace for diagnostics."
  type        = string
}

variable "disable_local_auth" {
  description = "Flag to disable local authentication for the AI Foundry resource."
  type        = bool
  default     = true
}
