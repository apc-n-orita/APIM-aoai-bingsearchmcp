terraform {
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.0.0"
    }
  }
}

locals {
  logsettings = ["remaining-tokens"]
}

data "azurerm_api_management" "apim" {
  name                = var.api_management_name
  resource_group_name = data.azurerm_resource_group.rg.name
}
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}
resource "azurerm_api_management_api" "openai" {
  name                  = "openai"
  resource_group_name   = data.azurerm_resource_group.rg.name
  api_management_name   = data.azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "openai-api"
  path                  = "openai"
  description           = "Azure Open AI API"
  protocols             = ["https"]
  subscription_required = true

  subscription_key_parameter_names {
    header = "api-key"
    query  = "subscription-key"
  }

  import {
    content_format = "openapi"
    content_value = templatefile("${path.module}/files/api/openai_openapi.yaml",
      {
        apim_gateway_url   = data.azurerm_api_management.apim.gateway_url
        aoai_model         = var.openai_model.model
        aoai_model_version = var.openai_model.version
      }
    )
  }
}

resource "azapi_resource" "act_aoai_backend" {
  type      = "Microsoft.ApiManagement/service/backends@2024-05-01"
  name      = "act-aoai"
  parent_id = data.azurerm_api_management.apim.id

  body = {
    properties = {
      protocol = "http"
      url      = "${var.act_aoai_backend_url}openai"
      circuitBreaker = {
        rules = [
          {
            name             = "openAIBreakerRule"
            acceptRetryAfter = true
            tripDuration     = "PT1M"
            failureCondition = {
              count    = 3
              interval = "PT5M"
              statusCodeRanges = [
                {
                  min = 429
                  max = 429
                },
                {
                  min = 500
                  max = 599
                }
              ]
            }
          }
        ]
      }
    }
  }
}

resource "azapi_resource" "std_aoai_backend" {
  type      = "Microsoft.ApiManagement/service/backends@2024-05-01"
  name      = "std-aoai"
  parent_id = data.azurerm_api_management.apim.id

  body = {
    properties = {
      protocol = "http"
      url      = "${var.std_aoai_backend_url}openai"
    }
  }
}
resource "azapi_resource" "backend_pool" {
  type                      = "Microsoft.ApiManagement/service/backends@2024-05-01"
  name                      = "backendpool"
  parent_id                 = data.azurerm_api_management.apim.id
  schema_validation_enabled = false # body.property配下のprotocol/url の検証を無効化
  body = {
    properties = {
      type = "Pool"
      pool = {
        services = [
          {
            id       = azapi_resource.act_aoai_backend.id
            priority = 1
          },
          {
            id       = azapi_resource.std_aoai_backend.id
            priority = 2
          }
        ]
      }
    }
  }
}
resource "azurerm_api_management_api_policy" "openai" {
  api_name            = azurerm_api_management_api.openai.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.rg.name
  xml_content         = file("${path.module}/files/policy/aoai_api.xml")

}

resource "azurerm_api_management_api_operation_policy" "openai_chat_operation" {
  api_name            = azurerm_api_management_api.openai.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.rg.name
  operation_id        = "ChatCompletions_Create-${var.openai_model.model}_${var.openai_model.version}"
  xml_content = templatefile("${path.module}/files/policy/aoai_chat_operation.xml", {
    backendpool   = azapi_resource.backend_pool.name
    tpmlimittoken = var.tpm_limit_token
  })
}

resource "azurerm_api_management_api_diagnostic" "openai" {
  identifier                = "applicationinsights"
  api_name                  = azurerm_api_management_api.openai.name
  api_management_name       = data.azurerm_api_management.apim.name
  resource_group_name       = data.azurerm_resource_group.rg.name
  api_management_logger_id  = var.api_management_logger_id
  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "information"
  http_correlation_protocol = "Legacy"

  frontend_request {
    body_bytes     = 8192
    headers_to_log = local.logsettings
  }

  frontend_response {
    body_bytes     = 8192
    headers_to_log = local.logsettings
  }

  backend_request {
    body_bytes     = 8192
    headers_to_log = local.logsettings
  }

  backend_response {
    body_bytes     = 8192
    headers_to_log = local.logsettings
  }
}

resource "azapi_update_resource" "apim_openai_api_diagnostic" {
  type        = "Microsoft.ApiManagement/service/apis/diagnostics@2024-06-01-preview"
  resource_id = azurerm_api_management_api_diagnostic.openai.id
  body = {
    properties = {
      metrics = true
    }
  }
}

resource "azapi_resource" "apim_openai_api_diagnostic_monitor" {
  type                      = "Microsoft.ApiManagement/service/apis/diagnostics@2024-05-01"
  name                      = "azuremonitor"
  parent_id                 = azurerm_api_management_api.openai.id
  schema_validation_enabled = false
  body = {
    properties = {
      alwaysLog   = "allErrors"
      logClientIp = true
      verbosity   = "information"
      loggerId    = "${data.azurerm_api_management.apim.id}/loggers/azuremonitor"

      sampling = {
        percentage   = 100.0
        samplingType = "fixed"
      }

      frontend = {
        request = {
          body = {
            bytes    = 0
            sampling = null
          }
          headers = []
        }
        response = {
          body = {
            bytes    = 0
            sampling = null
          }
          headers = []
        }
      }

      backend = {
        request = {
          body = {
            bytes    = 0
            sampling = null
          }
          headers = []
        }
        response = {
          body = {
            bytes    = 0
            sampling = null
          }
          headers = []
        }
      }

      largeLanguageModel = {
        logs = "enabled"
        requests = {
          maxSizeInBytes = 32768
          messages       = "all"
        }
        responses = {
          maxSizeInBytes = 32768
          messages       = "all"
        }
      }
    }
  }
}

resource "azurerm_role_assignment" "openai" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Cognitive Services OpenAI User"
  principal_id         = data.azurerm_api_management.apim.identity[0].principal_id
}

resource "azurerm_api_management_product_api" "openai" {
  api_name            = azurerm_api_management_api.openai.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = data.azurerm_resource_group.rg.name
  product_id          = var.product_id
}

