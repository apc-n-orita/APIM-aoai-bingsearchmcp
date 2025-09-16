variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "rg_name" {
  description = "The name of the resource group to deploy resources into"
  type        = string
}

variable "tags" {
  description = "A list of tags used for deployed services."
  type        = map(string)
}

variable "name" {
  description = "The name of the Azure Managed Grafana instance."
  type        = string
}

variable "grafana_major_version" {
  description = "Grafana major version."
  type        = number
  default     = 11
}

variable "deterministic_outbound_ip_enabled" {
  description = "Enable deterministic outbound IP."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access."
  type        = bool
  default     = false
}

variable "azure_monitor_workspace_integrations" {
  description = "List of Azure Monitor workspace integrations for Grafana. Each item is a map with key 'resource_id'."
  type        = list(object({ resource_id = string }))
  default     = []
}

variable "object_id" {
  description = "The object ID of the user or service principal to assign the Grafana Admin role."
  type        = string
}

variable "subscription_id" {
  description = "The subscription ID where the Monitoring Reader role will be assigned."
  type        = string
}

variable "api_key_enabled" {
  description = "Enable API key authentication."
  type        = bool
  default     = false
}
