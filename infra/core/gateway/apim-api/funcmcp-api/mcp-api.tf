terraform {
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
  }
}


data "azurerm_api_management" "apim" {
  name                = var.apim_service_name
  resource_group_name = var.resource_group_name
}


resource "azurerm_api_management_named_value" "function_host_key" {
  name                = "function-host-key"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "function-host-key"
  value               = var.masterkey
  secret              = true
}


resource "azurerm_api_management_api" "mcp" {
  name                  = var.api_name
  resource_group_name   = var.resource_group_name
  api_management_name   = data.azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "${upper(var.api_name)} MCP API"
  path                  = lower(var.api_name)
  protocols             = ["https"]
  service_url           = "${var.func_url}/runtime/webhooks/mcp"
  description           = "Model Context Protocol API endpoints for ${upper(var.api_name)}"
  subscription_required = true

  depends_on = [azurerm_api_management_named_value.function_host_key]
}

resource "azurerm_api_management_api_policy" "mcp" {
  api_name            = azurerm_api_management_api.mcp.name
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  xml_content = templatefile("${path.module}/files/policy/mcp_api_policy.xml", {
    function_host_key = azurerm_api_management_named_value.function_host_key.name
  })
}

resource "azurerm_api_management_api_operation" "mcp_sse" {
  operation_id        = "mcp-sse"
  api_name            = azurerm_api_management_api.mcp.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "MCP SSE Endpoint"
  method              = "GET"
  url_template        = "/sse"
  description         = "Server-Sent Events endpoint for MCP Server"
}

resource "azurerm_api_management_api_operation" "mcp_message" {
  operation_id        = "mcp-message"
  api_name            = azurerm_api_management_api.mcp.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "MCP Message Endpoint"
  method              = "POST"
  url_template        = "/message"
  description         = "Message endpoint for MCP Server"
}

resource "azurerm_api_management_api_diagnostic" "mcp" {
  identifier                = "applicationinsights"
  api_name                  = azurerm_api_management_api.mcp.name
  api_management_name       = data.azurerm_api_management.apim.name
  resource_group_name       = var.resource_group_name
  api_management_logger_id  = var.api_management_logger_id
  sampling_percentage       = 100.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "information"
  http_correlation_protocol = "Legacy"

  frontend_request {
    body_bytes     = 0
    headers_to_log = []
  }

  frontend_response {
    body_bytes     = 0
    headers_to_log = []
  }

  backend_request {
    body_bytes     = 0
    headers_to_log = []
  }

  backend_response {
    body_bytes     = 0
    headers_to_log = []
  }
}

resource "azurerm_api_management_product_api" "mcp" {
  api_name            = azurerm_api_management_api.mcp.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  product_id          = var.product_id
}
