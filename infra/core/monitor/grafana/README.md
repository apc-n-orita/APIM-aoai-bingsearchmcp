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
| [azurerm_dashboard_grafana.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/dashboard_grafana) | resource |
| [azurerm_role_assignment.admin_grafana_access](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.grafana_monitoring_reader](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the Azure Managed Grafana instance. | `string` | n/a | yes |
| <a name="input_object_id"></a> [object\_id](#input\_object\_id) | The object ID of the user or service principal to assign the Grafana Admin role. | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group to deploy resources into | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID where the Monitoring Reader role will be assigned. | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags used for deployed services. | `map(string)` | n/a | yes |
| <a name="input_api_key_enabled"></a> [api\_key\_enabled](#input\_api\_key\_enabled) | Enable API key authentication. | `bool` | `false` | no |
| <a name="input_azure_monitor_workspace_integrations"></a> [azure\_monitor\_workspace\_integrations](#input\_azure\_monitor\_workspace\_integrations) | List of Azure Monitor workspace integrations for Grafana. Each item is a map with key 'resource\_id'. | `list(object({ resource_id = string }))` | `[]` | no |
| <a name="input_deterministic_outbound_ip_enabled"></a> [deterministic\_outbound\_ip\_enabled](#input\_deterministic\_outbound\_ip\_enabled) | Enable deterministic outbound IP. | `bool` | `true` | no |
| <a name="input_grafana_major_version"></a> [grafana\_major\_version](#input\_grafana\_major\_version) | Grafana major version. | `number` | `11` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Enable public network access. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_grafana_endpoint"></a> [grafana\_endpoint](#output\_grafana\_endpoint) | n/a |
| <a name="output_grafana_id"></a> [grafana\_id](#output\_grafana\_id) | n/a |
<!-- END_TF_DOCS -->