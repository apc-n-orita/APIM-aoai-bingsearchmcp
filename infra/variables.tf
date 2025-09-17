# Input variables for the module

variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
}
variable "subscription_id" {
  description = "The subscription ID to deploy the resources"
  type        = string
}
variable "openai" {
  description = "OpenAI Cognitive Services の構成情報"
  type = object({
    locations = list(string)
    model = object({
      model      = string
      version    = string
      deploytype = string
      capacity   = number
    })
  })

  validation {
    condition     = length(var.openai.locations) == 2
    error_message = "The 'locations' list must contain exactly 2 elements."
  }
}

variable "bingsearch_ai" {
  description = "Bing Search 用 AI model deployment configuration."
  type = object({
    location = string
    model = object({
      model      = string
      version    = string
      format     = string
      deploytype = string
      capacity   = number
    })
  })
}
