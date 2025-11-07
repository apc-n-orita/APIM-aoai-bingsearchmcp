<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.42.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cosmosdb_account.sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) | resource |
| [azurerm_cosmosdb_sql_container.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_container) | resource |
| [azurerm_cosmosdb_sql_database.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_database) | resource |
| [azurerm_cosmosdb_sql_role_assignment.builtin_data_contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_sql_role_assignment) | resource |
| [azurerm_monitor_diagnostic_setting.cosmos_sql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_management_name"></a> [api\_management\_name](#input\_api\_management\_name) | API Management service name | `string` | n/a | yes |
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Cosmos SQL database name | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | Log Analytics workspace ID | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name | `string` | n/a | yes |
| <a name="input_sql_account_name"></a> [sql\_account\_name](#input\_sql\_account\_name) | Cosmos DB SQL API account name (unique globally). 指定なければ命名接頭辞 + 'sql' を推奨 | `string` | n/a | yes |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Cosmos SQL container name | `string` | `"clientregistrations"` | no |
| <a name="input_default_ttl"></a> [default\_ttl](#input\_default\_ttl) | Default TTL (in seconds) for items in the Cosmos DB SQL container. Use -1 for infinite TTL. | `number` | `-1` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable public network access to Cosmos DB account | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags map | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cosmos_sql_account_name"></a> [cosmos\_sql\_account\_name](#output\_cosmos\_sql\_account\_name) | n/a |
| <a name="output_cosmos_sql_container_name"></a> [cosmos\_sql\_container\_name](#output\_cosmos\_sql\_container\_name) | n/a |
| <a name="output_cosmos_sql_database_name"></a> [cosmos\_sql\_database\_name](#output\_cosmos\_sql\_database\_name) | n/a |
| <a name="output_cosmos_sql_endpoint"></a> [cosmos\_sql\_endpoint](#output\_cosmos\_sql\_endpoint) | n/a |
<!-- END_TF_DOCS -->