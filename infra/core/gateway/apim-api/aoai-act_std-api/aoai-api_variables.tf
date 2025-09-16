variable "resource_group_name" {}
variable "api_management_name" {}
variable "openai_model" {
  description = "Model configuration for OpenAI deployment"
  type = object({
    model      = string
    version    = string
    deploytype = string
    capacity   = number
  })
}

variable "act_aoai_backend_url" {
  type = string
}

variable "std_aoai_backend_url" {
  type = string
}

variable "product_id" {
  type = string
}

variable "api_management_logger_id" {
  type = string

}

variable "tpm_limit_token" {
  description = "Tokens per minute limit for OpenAI"
  type        = number
  default     = 30000
}
