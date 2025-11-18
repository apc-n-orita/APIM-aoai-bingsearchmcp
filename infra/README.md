<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7, < 2.0.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.0.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | ~>3.5.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~>1.2.24 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.42.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~>3.7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.0.1 |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.5.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.31 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.42.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.5.3 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ai_foundry"></a> [ai\_foundry](#module\_ai\_foundry) | ./core/AI/aiservice | n/a |
| <a name="module_aoai_api"></a> [aoai\_api](#module\_aoai\_api) | ./core/gateway/apim-api/aoai-act_std-api | n/a |
| <a name="module_apim"></a> [apim](#module\_apim) | ./core/gateway/apim | n/a |
| <a name="module_bingsearchmcp"></a> [bingsearchmcp](#module\_bingsearchmcp) | ./app/function/app | n/a |
| <a name="module_cosmos_sql_oauth"></a> [cosmos\_sql\_oauth](#module\_cosmos\_sql\_oauth) | ./core/database/cosmos | n/a |
| <a name="module_fC-appserviceplan"></a> [fC-appserviceplan](#module\_fC-appserviceplan) | ./core/host/appserviceplan | n/a |
| <a name="module_func-role"></a> [func-role](#module\_func-role) | ./app/function/role | n/a |
| <a name="module_func-storage"></a> [func-storage](#module\_func-storage) | ./core/storage | n/a |
| <a name="module_funcmcp_api"></a> [funcmcp\_api](#module\_funcmcp\_api) | ./core/gateway/apim-api/funcmcp-api | n/a |
| <a name="module_funcmcp_oauth_api"></a> [funcmcp\_oauth\_api](#module\_funcmcp\_oauth\_api) | ./core/gateway/apim-api/funcmcp-oauth-api | n/a |
| <a name="module_grafana"></a> [grafana](#module\_grafana) | ./core/monitor/grafana | n/a |
| <a name="module_oauth_api"></a> [oauth\_api](#module\_oauth\_api) | ./core/gateway/apim-api/oauth-api | n/a |
| <a name="module_openai"></a> [openai](#module\_openai) | ./core/AI/aoai | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.acc_connection_aoai](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.acc_connection_appinsights](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.acc_connection_gwbs](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.ai_foundry_project](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource.bing_account](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azapi_resource_action.bing_keys](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurecaf_name.aoai_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.apim_appinsights_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.apim_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.appserviceplan_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.cosmos_sql_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.func_appinsights_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.functionapp_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.law_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.rg_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurecaf_name.storage_name](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azurerm_api_management_product.sa_ai_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_product) | resource |
| [azurerm_api_management_subscription.sa_ai_api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_subscription) | resource |
| [azurerm_application_insights.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_application_insights.func](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_log_analytics_workspace.law](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.func_ai_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_user_assigned_identity.apim_entraid](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [azurerm_user_assigned_identity.func](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [local_file.output_tfvars](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [time_sleep.wait_project_identities](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bingsearch_ai"></a> [bingsearch\_ai](#input\_bingsearch\_ai) | Bing Search 用 AI model deployment configuration. | <pre>object({<br/>    location = string<br/>    model = object({<br/>      model      = string<br/>      version    = string<br/>      format     = string<br/>      deploytype = string<br/>      capacity   = number<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_environment_name"></a> [environment\_name](#input\_environment\_name) | The name of the azd environment to be deployed | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_openai"></a> [openai](#input\_openai) | OpenAI Cognitive Services の構成情報 | <pre>object({<br/>    locations = list(string)<br/>    model = object({<br/>      model      = string<br/>      version    = string<br/>      deploytype = string<br/>      capacity   = number<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID to deploy the resources | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_AZURE_LOCATION"></a> [AZURE\_LOCATION](#output\_AZURE\_LOCATION) | n/a |
| <a name="output_AZURE_TENANT_ID"></a> [AZURE\_TENANT\_ID](#output\_AZURE\_TENANT\_ID) | n/a |
| <a name="output_GRAFANA_WORKSPACE_NAME"></a> [GRAFANA\_WORKSPACE\_NAME](#output\_GRAFANA\_WORKSPACE\_NAME) | n/a |
| <a name="output_SERVICE_AOAI_ENDPOINTS"></a> [SERVICE\_AOAI\_ENDPOINTS](#output\_SERVICE\_AOAI\_ENDPOINTS) | n/a |
| <a name="output_SERVICE_AOAI_ENDPOINTS_SUBSCRIPTIONKEY"></a> [SERVICE\_AOAI\_ENDPOINTS\_SUBSCRIPTIONKEY](#output\_SERVICE\_AOAI\_ENDPOINTS\_SUBSCRIPTIONKEY) | n/a |
| <a name="output_SERVICE_BINGSEARCHMCP_ENDPOINTS"></a> [SERVICE\_BINGSEARCHMCP\_ENDPOINTS](#output\_SERVICE\_BINGSEARCHMCP\_ENDPOINTS) | n/a |
| <a name="output_SERVICE_BINGSEARCHMCP_ENDPOINTS_SUBSCRIPTIONKEY"></a> [SERVICE\_BINGSEARCHMCP\_ENDPOINTS\_SUBSCRIPTIONKEY](#output\_SERVICE\_BINGSEARCHMCP\_ENDPOINTS\_SUBSCRIPTIONKEY) | n/a |
| <a name="output_SERVICE_OAUTH_BINGSEARCHMCP_ENDPOINTS"></a> [SERVICE\_OAUTH\_BINGSEARCHMCP\_ENDPOINTS](#output\_SERVICE\_OAUTH\_BINGSEARCHMCP\_ENDPOINTS) | n/a |
<!-- END_TF_DOCS -->