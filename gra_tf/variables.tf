# Input variables for the module

variable "apim_appinsight_name" {
  description = "APIM用Application Insights名"
  type        = string
}

variable "func_appinsight_name" {
  description = "Function App用Application Insights名"
  type        = string
}

variable "ai_foundry_resources" {
  description = "AI Foundryリソース情報リスト"
  type = list(object({
    name     = string
    location = string
  }))
}

variable "openai_resources" {
  description = "OpenAIリソース情報リスト"
  type = list(object({
    name     = string
    location = string
  }))
}

variable "grafana_endpoint" {
  description = "GrafanaのエンドポイントURL"
  type        = string
}


variable "rg_name" {
  description = "Resource Group名"
  type        = string
}



variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}


variable "subscription_id" {
  description = "The subscription ID to deploy the resources"
  type        = string
}

variable "law_name" {
  description = "Law用Application Insights名"
  type        = string
}

variable "apim_name" {
  description = "APIM名"
  type        = string
}
