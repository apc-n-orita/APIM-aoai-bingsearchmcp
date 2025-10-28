locals {
  tags           = { azd-env-name : var.environment_name, owner : "n-orita" }
  sha            = base64encode(sha256("${var.environment_name}${var.location}${data.azurerm_client_config.current.subscription_id}"))
  resource_token = substr(replace(lower(local.sha), "[^A-Za-z0-9_]", ""), 0, 13)
  apim = {
    sku             = "BasicV2"
    skuCount        = 1
    publisher_email = "testuser@example.com"
    publisher_name  = "testuser"
  }
  func = {
    tags = merge(local.tags, { azd-service-name = "bingsearchmcp" })
    app_settings = [
      {
        name  = "PROJECT_ENDPOINT"
        value = "https://aif-${var.environment_name}-${substr(local.resource_token, 0, 3)}.services.ai.azure.com/api/projects/aif-${var.environment_name}-${substr(local.resource_token, 0, 3)}-project"
      },
      {
        name  = "MODEL_DEPLOYMENT_NAME"
        value = "${var.bingsearch_ai.model.model}_${var.bingsearch_ai.model.version}"
      },
      {
        name  = "AZURE_BING_CONNECTION_ID"
        value = azapi_resource.acc_connection_gwbs.id
        #value = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.rg.name}/providers/Microsoft.CognitiveServices/accounts/aif-${var.environment_name}-${substr(local.resource_token, 0, 3)}/connections/${replace(azapi_resource.bing_account.name, "-", "")}"
      },
      {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.func.client_id
      },
      {
        name  = "AZURE_TENANT_ID"
        value = data.azurerm_client_config.current.tenant_id
      }
    ]
  }
  content_filters = [
    {
      severityThreshold = "High"
      blocking          = true
      enabled           = true
      name              = "Violence"
      source            = "Prompt"
    },
    {
      severityThreshold = "High"
      blocking          = true
      enabled           = true
      name              = "Hate"
      source            = "Prompt"
    },
    {
      severityThreshold = "High"
      blocking          = true
      enabled           = true
      name              = "Sexual"
      source            = "Prompt"
    },
    {
      severityThreshold = "High"
      blocking          = true
      enabled           = true
      name              = "Selfharm"
      source            = "Prompt"
    },
    {
      blocking = true
      enabled  = true
      name     = "Jailbreak"
      source   = "Prompt"
    },
    {
      blocking = false
      enabled  = false
      name     = "Indirect Attack"
      source   = "Prompt"
    },
    {
      severityThreshold = "High"
      blocking          = true
      enabled           = true
      name              = "Violence"
      source            = "Completion"
    },
    {
      severityThreshold = "High"
      blocking          = true
      enabled           = true
      name              = "Hate"
      source            = "Completion"
    },
    {
      severityThreshold = "High"
      blocking          = true
      enabled           = true
      name              = "Sexual"
      source            = "Completion"
    },
    {
      severityThreshold = "High"
      blocking          = true
      enabled           = true
      name              = "Selfharm"
      source            = "Completion"
    },
    {
      blocking = true
      enabled  = true
      name     = "Jailbreak"
      source   = "Completion"
    },
    {
      blocking = false
      enabled  = false
      name     = "Indirect Attack"
      source   = "Completion"
    }
  ]
}

resource "azurecaf_name" "rg_name" {
  name          = var.environment_name
  resource_type = "azurerm_resource_group"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "cosmos_sql_name" {
  name          = var.environment_name
  resource_type = "azurerm_cosmosdb_account"
  random_length = 0
  prefixes      = ["oauth"]
  clean_input   = true
}

resource "azurecaf_name" "law_name" {
  name          = var.environment_name
  resource_type = "azurerm_log_analytics_workspace"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "apim_name" {
  name          = var.environment_name
  resource_type = "azurerm_api_management"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "apim_appinsights_name" {
  name          = azurecaf_name.apim_name.result
  resource_type = "azurerm_application_insights"
  random_length = 0
  clean_input   = true
}
resource "azurecaf_name" "func_appinsights_name" {
  name          = azurecaf_name.functionapp_name.result
  resource_type = "azurerm_application_insights"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "aoai_name" {
  name          = var.environment_name
  resource_type = "azurerm_cognitive_account"
  prefixes      = ["aoai"]
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "appserviceplan_name" {
  name          = var.environment_name
  resource_type = "azurerm_app_service_plan"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "functionapp_name" {
  name          = var.environment_name
  resource_type = "azurerm_function_app"
  random_length = 0
  clean_input   = true
}

resource "azurecaf_name" "storage_name" {
  name          = var.environment_name
  resource_type = "azurerm_storage_account"
  random_length = 0
  clean_input   = true
}
# Deploy resource group
resource "azurerm_resource_group" "rg" {
  name     = azurecaf_name.rg_name.result
  location = var.location
  // Tag the resource group with the azd environment name
  // This should also be applied to all resources created in this module
  tags = { azd-env-name : var.environment_name }
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = azurecaf_name.law_name.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_user_assigned_identity" "apim_entraid" {
  name                = "apim-user-identity"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}


resource "azurerm_application_insights" "apim" {
  name                          = "${azurecaf_name.apim_appinsights_name.result}-${substr(local.resource_token, 0, 3)}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  application_type              = "web"
  workspace_id                  = azurerm_log_analytics_workspace.law.id
  local_authentication_disabled = true
}


module "apim" {
  source = "./core/gateway/apim"

  location                          = var.location
  rg_name                           = azurerm_resource_group.rg.name
  tags                              = local.tags
  sku                               = local.apim.sku
  skuCount                          = local.apim.skuCount
  name                              = "${azurecaf_name.apim_name.result}-${substr(local.resource_token, 0, 3)}"
  publisher_email                   = local.apim.publisher_email
  publisher_name                    = local.apim.publisher_name
  application_insights_name         = azurerm_application_insights.apim.name
  identity_type                     = "SystemAssigned, UserAssigned"
  azurerm_user_assigned_identity_id = azurerm_user_assigned_identity.apim_entraid.id
  log_analytics_workspace_id        = azurerm_log_analytics_workspace.law.id
}

module "openai" {
  source              = "./core/AI/aoai"
  name                = "${azurecaf_name.aoai_name.result}-${substr(local.resource_token, 0, 3)}"
  openai_model        = var.openai.model
  openai_locations    = var.openai.locations
  resource_group_name = azurerm_resource_group.rg.name
  #content_filters            = local.content_filters
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

resource "azurerm_api_management_product" "sa_ai_api" {
  product_id            = "sa_ai_api"
  api_management_name   = module.apim.APIM_SERVICE_NAME
  resource_group_name   = azurerm_resource_group.rg.name
  display_name          = "SA ai Api"
  subscription_required = true
  approval_required     = false
  published             = true
}

resource "azurerm_api_management_subscription" "sa_ai_api" {
  api_management_name = module.apim.APIM_SERVICE_NAME
  resource_group_name = azurerm_resource_group.rg.name
  product_id          = azurerm_api_management_product.sa_ai_api.id
  display_name        = "test_sa_ai_api"
  subscription_id     = "testsaaiapi"
  allow_tracing       = false
  state               = "active"
}


module "aoai_api" {
  source = "./core/gateway/apim-api/aoai-act_std-api"

  resource_group_name      = azurerm_resource_group.rg.name
  api_management_name      = module.apim.APIM_SERVICE_NAME
  openai_model             = var.openai.model
  act_aoai_backend_url     = module.openai.cognitive_account_endpoints[var.openai.locations[0]]
  std_aoai_backend_url     = module.openai.cognitive_account_endpoints[var.openai.locations[1]]
  product_id               = azurerm_api_management_product.sa_ai_api.product_id
  api_management_logger_id = module.apim.API_MANAGEMENT_LOGGER_ID
  tpm_limit_token          = 40000


}

resource "azurerm_application_insights" "func" {
  name                          = "${azurecaf_name.func_appinsights_name.result}-${substr(local.resource_token, 0, 3)}"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  application_type              = "web"
  workspace_id                  = azurerm_log_analytics_workspace.law.id
  local_authentication_disabled = true
}

resource "azurerm_user_assigned_identity" "func" {
  name                = "func"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_role_assignment" "func_ai_user" {
  scope                = azapi_resource.ai_foundry_project.id
  role_definition_name = "Azure AI User"
  principal_id         = azurerm_user_assigned_identity.func.principal_id
}

module "fC-appserviceplan" {
  source   = "./core/host/appserviceplan"
  name     = "${azurecaf_name.appserviceplan_name.result}-${substr(local.resource_token, 0, 3)}"
  location = var.location
  rg_name  = azurerm_resource_group.rg.name
  tags     = local.tags
  sku_name = "FC1"
  os_type  = "Linux"
}

module "bingsearchmcp" {
  source                                 = "./app/function/app"
  name                                   = "func-${var.environment_name}-gwbs-${substr(local.resource_token, 0, 3)}"
  location                               = var.location
  rg_id                                  = azurerm_resource_group.rg.id
  tags                                   = local.func.tags
  app_service_plan_id                    = module.fC-appserviceplan.APPSERVICE_PLAN_ID
  app_settings                           = local.func.app_settings
  runtime_name                           = "python"
  runtime_version                        = "3.11"
  storage_account_name                   = module.func-storage.name
  function_storage_id                    = module.func-storage.storage_account_id
  primary_blob_endpoint                  = module.func-storage.primary_blob_endpoint
  application_insights_connection_string = azurerm_application_insights.func.connection_string
  identity_client_id                     = azurerm_user_assigned_identity.func.client_id
  identity_id                            = azurerm_user_assigned_identity.func.id

  depends_on = [module.func-storage]
}

module "func-role" {
  source                              = "./app/function/role"
  storage_account_scope_id            = module.func-storage.storage_account_id
  monitor_scope_id                    = azurerm_application_insights.func.id
  user_assigned_identity_principal_id = azurerm_user_assigned_identity.func.principal_id
}

module "func-storage" {
  source                     = "./core/storage"
  name                       = lower("${azurecaf_name.storage_name.result}${substr(local.resource_token, 0, 3)}")
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tags                       = local.tags
  shared_access_key_enabled  = false
  tier                       = "Standard"
  replication_type           = "LRS"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}


module "ai_foundry" {
  source                     = "./core/AI/aiservice"
  name                       = "aif-${var.environment_name}-${substr(local.resource_token, 0, 3)}"
  location                   = var.bingsearch_ai.location
  ai_model                   = var.bingsearch_ai.model
  resource_group_name        = azurerm_resource_group.rg.name
  tags                       = local.tags
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

resource "azapi_resource" "ai_foundry_project" {
  type                      = "Microsoft.CognitiveServices/accounts/projects@2025-06-01"
  name                      = "${module.ai_foundry.name}-project"
  parent_id                 = module.ai_foundry.ai_foundry_id
  location                  = var.bingsearch_ai.location
  schema_validation_enabled = false

  body = {
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }

    properties = {
      displayName = "${module.ai_foundry.name}-project"
      description = "A project for the AI Foundry account Agent"
    }
  }
  depends_on = [
    module.ai_foundry
  ]
  response_export_values = [
    "identity.principalId",
    "properties.internalId"
  ]
}

## Wait 10 seconds for the AI Foundry project system-assigned managed identity to be created and to replicate
## through Entra ID
resource "time_sleep" "wait_project_identities" {
  depends_on = [
    azapi_resource.ai_foundry_project
  ]
  create_duration = "10s"
}


resource "azapi_resource" "bing_account" {
  type                      = "Microsoft.Bing/accounts@2020-06-10"
  name                      = lower("gwbs-${var.environment_name}-${substr(local.resource_token, 0, 3)}")
  location                  = "global"
  parent_id                 = azurerm_resource_group.rg.id
  schema_validation_enabled = false


  tags = local.tags

  body = {
    sku = {
      name = "G1"
    }
    kind = "Bing.Grounding"
    properties = {
      statisticsEnabled = false
    }
  }

  response_export_values = [
    "*"
  ]
}

resource "azapi_resource_action" "bing_keys" {
  type                   = "Microsoft.Bing/accounts@2020-06-10"
  resource_id            = azapi_resource.bing_account.id
  action                 = "listKeys"
  method                 = "POST"
  response_export_values = ["*"]
}

resource "azapi_resource" "acc_connection_gwbs" {
  type                      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name                      = "gwbs-connection"
  parent_id                 = azapi_resource.ai_foundry_project.id
  schema_validation_enabled = false

  body = {
    properties = {
      category      = "ApiKey"
      target        = "https://api.bing.microsoft.com/"
      authType      = "ApiKey"
      isSharedToAll = false
      credentials = {
        key = azapi_resource_action.bing_keys.output.key1
      }
      metadata = {
        ApiType    = "Azure"
        Type       = "bing_grounding"
        ResourceId = azapi_resource.bing_account.id
      }
    }
  }
}



resource "azapi_resource" "acc_connection_aoai" {
  for_each                  = toset(var.openai.locations)
  type                      = "Microsoft.CognitiveServices/accounts/projects/connections@2025-04-01-preview"
  name                      = "aoai-connection-${substr(each.value, 0, 3)}"
  parent_id                 = azapi_resource.ai_foundry_project.id
  schema_validation_enabled = false

  body = {
    properties = {
      category      = "AzureOpenAI"
      target        = "${module.apim.gateway_url}/"
      authType      = "ApiKey"
      isSharedToAll = false
      credentials = {
        key = azurerm_api_management_subscription.sa_ai_api.primary_key
      }
      metadata = {
        ApiType              = "Azure"
        ApiVersion           = "2023-07-01-preview"
        DeploymentApiVersion = "2023-10-01-preview"
        Location             = each.value
        ResourceId           = module.openai.cognitive_account_ids[each.value]
      }
      useWorkspaceManagedIdentity = true
    }
  }
}

module "funcmcp_api" {
  source                   = "./core/gateway/apim-api/funcmcp-api"
  resource_group_name      = azurerm_resource_group.rg.name
  apim_service_name        = module.apim.APIM_SERVICE_NAME
  function_app_name        = module.bingsearchmcp.name
  func_url                 = module.bingsearchmcp.uri
  masterkey                = module.bingsearchmcp.masterkey
  product_id               = azurerm_api_management_product.sa_ai_api.product_id
  api_name                 = "bingsearch"
  api_management_logger_id = module.apim.API_MANAGEMENT_LOGGER_ID
  depends_on               = [module.bingsearchmcp]
}

module "funcmcp_oauth_api" {
  source                   = "./core/gateway/apim-api/funcmcp-oauth-api"
  resource_group_name      = azurerm_resource_group.rg.name
  apim_service_name        = module.apim.APIM_SERVICE_NAME
  function_app_name        = module.bingsearchmcp.name
  func_url                 = module.bingsearchmcp.uri
  product_id               = azurerm_api_management_product.sa_ai_api.product_id
  api_name                 = "bingsearch"
  api_management_logger_id = module.apim.API_MANAGEMENT_LOGGER_ID
  depends_on               = [module.funcmcp_api, module.oauth_api]
}

module "oauth_api" {
  source                      = "./core/gateway/apim-api/oauth-api"
  resource_group_name         = azurerm_resource_group.rg.name
  apim_service_name           = module.apim.APIM_SERVICE_NAME
  api_management_logger_id    = module.apim.API_MANAGEMENT_LOGGER_ID
  entra_app_tenant_id         = data.azuread_client_config.current.tenant_id
  entra_app_uami_client_id    = azurerm_user_assigned_identity.apim_entraid.client_id
  entra_app_display_name      = "mcp-oauth-test-${substr(local.resource_token, 0, 3)}"
  entra_app_uami_principal_id = azurerm_user_assigned_identity.apim_entraid.principal_id
  azureuser_object_id         = data.azuread_client_config.current.object_id
  cosmos_db_account_name      = module.cosmos_sql_oauth.cosmos_sql_account_name
  cosmos_db_database_name     = module.cosmos_sql_oauth.cosmos_sql_database_name
  cosmos_db_container_name    = module.cosmos_sql_oauth.cosmos_sql_container_name
}


# --- Grafana Custom Module ---
module "grafana" {
  source                            = "./core/monitor/grafana"
  name                              = lower("graf-${var.environment_name}-${substr(local.resource_token, 0, 3)}")
  rg_name                           = azurerm_resource_group.rg.name
  location                          = var.location
  tags                              = local.tags
  grafana_major_version             = 11
  deterministic_outbound_ip_enabled = true
  public_network_access_enabled     = true
  object_id                         = data.azurerm_client_config.current.object_id
  subscription_id                   = var.subscription_id
  api_key_enabled                   = true
}

resource "local_file" "output_tfvars" {
  filename = "../gra_tf/terraform.tfvars"
  content = <<-EOT
  apim_name = "${module.apim.APIM_SERVICE_NAME}"
  law_name = "${azurerm_log_analytics_workspace.law.name}"
  apim_appinsight_name    = "${azurerm_application_insights.apim.name}"
  func_appinsight_name    = "${azurerm_application_insights.func.name}"
  ai_foundry_resources = [
   {
      name     = "aif-${var.environment_name}-${substr(local.resource_token, 0, 3)}"
      location = "${var.bingsearch_ai.location}"
   },
  ]
  openai_resources = [
${join("\n", [
  for location, account in module.openai.cognitive_account_names :
  "   {\n    name     = \"${account}\"\n    location = \"${location}\"\n   },"
])}
  ]

  grafana_endpoint       = "${module.grafana.grafana_endpoint}"
  rg_name                = "${azurerm_resource_group.rg.name}"
  location               = "${var.location}"
  subscription_id        = "${var.subscription_id}"
  EOT
}


module "cosmos_sql_oauth" {
  source                        = "./core/database/cosmos"
  sql_account_name              = azurecaf_name.cosmos_sql_name.result
  database_name                 = "oauthdb"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  tags                          = local.tags
  api_management_name           = module.apim.APIM_SERVICE_NAME
  public_network_access_enabled = true
  log_analytics_workspace_id    = azurerm_log_analytics_workspace.law.id
  #OAuth認証時に "State parameter does not match consented state." エラーが発生することがある
  #VSCodeでクライアントIDを毎回リセットする必要があり、未使用のクライアントIDがDBに蓄積されてしまう
  #その対策として、default_ttl を 10,800（3時間）に設定し、不要なクライアントIDが自動的に期限切れになるようにした
  default_ttl = 10800
}

