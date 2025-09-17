terraform {
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.7.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.5.0"
    }
  }
}


resource "azuread_application" "entra_app" {
  display_name = var.entra_app_display_name
  owners       = [var.azureuser_object_id]
  web {
    redirect_uris = ["${data.azurerm_api_management.apim.gateway_url}/oauth-callback"]
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    resource_access {
      id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read
      type = "Scope"
    }
  }
}

resource "azuread_application_federated_identity_credential" "fic" {
  application_id = azuread_application.entra_app.id
  display_name   = "msiAsFic"
  description    = "Trust the user-assigned MI as a credential for the app"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://login.microsoftonline.com/${var.entra_app_tenant_id}/v2.0"
  subject        = var.entra_app_uami_principal_id
}


data "azurerm_api_management" "apim" {
  name                = var.apim_service_name
  resource_group_name = var.resource_group_name
}

# --- Named Values ---
resource "azurerm_api_management_named_value" "entra_id_tenant_id" {
  name                = "EntraIDTenantId"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "EntraIDTenantId"
  value               = var.entra_app_tenant_id
  secret              = false
}

resource "azurerm_api_management_named_value" "entra_id_client_id" {
  name                = "EntraIDClientId"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "EntraIDClientId"
  value               = azuread_application.entra_app.client_id
  secret              = false
}

resource "azurerm_api_management_named_value" "entra_id_fic_client_id" {
  name                = "EntraIDFicClientId"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "EntraIdFicClientId"
  value               = var.entra_app_uami_client_id
  secret              = false
}

resource "azurerm_api_management_named_value" "mcp_client_id" {
  name                = "McpClientId"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "McpClientId"
  value               = azuread_application.entra_app.client_id
  secret              = false
}

resource "azurerm_api_management_named_value" "apim_gateway_url" {
  name                = "APIMGatewayURL"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "APIMGatewayURL"
  value               = data.azurerm_api_management.apim.gateway_url
  secret              = false
}

resource "azurerm_api_management_named_value" "mcp_server_name" {
  name                = "MCPServerName"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "MCPServerName"
  value               = "MCP Server"
  secret              = false
}

resource "azurerm_api_management_named_value" "oauth_callback_uri" {
  name                = "OAuthCallbackUri"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "OAuthCallbackUri"
  value               = "${data.azurerm_api_management.apim.gateway_url}/oauth-callback"
  secret              = false
}

resource "azurerm_api_management_named_value" "oauth_scopes" {
  name                = "OAuthScopes"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "OAuthScopes"
  value               = "openid https://graph.microsoft.com/.default"
  secret              = false
}

resource "random_bytes" "IV" {
  length = 16
}

resource "random_bytes" "Key" {
  length = 32
}

resource "azurerm_api_management_named_value" "EncryptionIV" {
  name                = "EncryptionIV"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "EncryptionIV"
  value               = random_bytes.IV.base64
  secret              = true
}

resource "azurerm_api_management_named_value" "EncryptionKey" {
  name                = "EncryptionKey"
  resource_group_name = var.resource_group_name
  api_management_name = data.azurerm_api_management.apim.name
  display_name        = "EncryptionKey"
  value               = random_bytes.Key.base64
  secret              = true
}

# --- OAuth API ---
resource "azurerm_api_management_api" "oauth" {
  name                  = "oauth"
  resource_group_name   = var.resource_group_name
  api_management_name   = data.azurerm_api_management.apim.name
  revision              = "1"
  display_name          = "OAuth"
  description           = "OAuth 2.0 Authentication API"
  subscription_required = false
  path                  = ""
  protocols             = ["https"]
  service_url           = "https://login.microsoftonline.com/${var.entra_app_tenant_id}/oauth2/v2.0"
}

resource "azurerm_api_management_api_diagnostic" "oauth" {
  identifier                = "applicationinsights"
  api_name                  = azurerm_api_management_api.oauth.name
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

resource "azurerm_api_management_api_policy" "oauth" {
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/oauth_api_policy.xml")

}

# --- Operations & Policies ---
resource "azurerm_api_management_api_operation" "oauth_authorize" {
  operation_id        = "authorize"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Authorize"
  method              = "GET"
  url_template        = "/authorize"
  description         = "OAuth 2.0 authorization endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_authorize_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_authorize.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/authorize_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}

resource "azurerm_api_management_api_operation" "oauth_token" {
  operation_id        = "token"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Token"
  method              = "POST"
  url_template        = "/token"
  description         = "OAuth 2.0 token endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_token_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_token.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/token_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}

resource "azurerm_api_management_api_operation" "oauth_callback" {
  operation_id        = "oauth-callback"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "OAuth Callback"
  method              = "GET"
  url_template        = "/oauth-callback"
  description         = "OAuth 2.0 callback endpoint to handle authorization code flow"
}

resource "azurerm_api_management_api_operation_policy" "oauth_callback_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_callback.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/oauth-callback_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}

resource "azurerm_api_management_api_operation" "oauth_register" {
  operation_id        = "register"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Register"
  method              = "POST"
  url_template        = "/register"
  description         = "OAuth 2.0 client registration endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_register_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_register.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/register_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}

resource "azurerm_api_management_api_operation" "oauth_register_options" {
  operation_id        = "register-options"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Register Options"
  method              = "OPTIONS"
  url_template        = "/register"
  description         = "CORS preflight request handler for register endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_register_options_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_register_options.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/register-options_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}

resource "azurerm_api_management_api_operation" "oauth_metadata_options" {
  operation_id        = "oauthmetadata-options"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "OAuth Metadata Options"
  method              = "OPTIONS"
  url_template        = "/.well-known/oauth-authorization-server"
  description         = "CORS preflight request handler for OAuth metadata endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_metadata_options_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_metadata_options.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/oauthmetadata-options_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}

resource "azurerm_api_management_api_operation" "oauth_metadata_get" {
  operation_id        = "oauthmetadata-get"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "OAuth Metadata Get"
  method              = "GET"
  url_template        = "/.well-known/oauth-authorization-server"
  description         = "OAuth 2.0 metadata endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_metadata_get_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_metadata_get.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/oauthmetadata-get_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}

resource "azurerm_api_management_api_operation" "oauth_consent_get" {
  operation_id        = "consent-get"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Consent Page"
  method              = "GET"
  url_template        = "/consent"
  description         = "Client consent page endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_consent_get_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_consent_get.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/consent_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}

resource "azurerm_api_management_api_operation" "oauth_consent_post" {
  operation_id        = "consent-post"
  api_name            = azurerm_api_management_api.oauth.name
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  display_name        = "Consent Submission"
  method              = "POST"
  url_template        = "/consent"
  description         = "Client consent submission endpoint"
}

resource "azurerm_api_management_api_operation_policy" "oauth_consent_post_policy" {
  api_name            = azurerm_api_management_api.oauth.name
  operation_id        = azurerm_api_management_api_operation.oauth_consent_post.operation_id
  api_management_name = data.azurerm_api_management.apim.name
  resource_group_name = var.resource_group_name
  xml_content         = file("${path.module}/files/policy/consent_policy.xml")
  depends_on = [
    azurerm_api_management_named_value.entra_id_tenant_id,
    azurerm_api_management_named_value.entra_id_client_id,
    azurerm_api_management_named_value.entra_id_fic_client_id,
    azurerm_api_management_named_value.mcp_client_id,
    azurerm_api_management_named_value.apim_gateway_url,
    azurerm_api_management_named_value.mcp_server_name,
    azurerm_api_management_named_value.oauth_callback_uri,
    azurerm_api_management_named_value.oauth_scopes,
    azurerm_api_management_named_value.EncryptionIV,
    azurerm_api_management_named_value.EncryptionKey
  ]
}
