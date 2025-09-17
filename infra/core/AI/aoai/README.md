<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~>2.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>4.42.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>4.42.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_cognitive_account.openai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account) | resource |
| [azurerm_cognitive_account_rai_policy.contentpolicy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_account_rai_policy) | resource |
| [azurerm_cognitive_deployment.deployment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cognitive_deployment) | resource |
| [azurerm_monitor_diagnostic_setting.openai](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#input\_log\_analytics\_workspace\_id) | 共通で使用する Log Analytics Workspace のリソース ID | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Base name for resources | `string` | n/a | yes |
| <a name="input_openai_locations"></a> [openai\_locations](#input\_openai\_locations) | List of locations for each OpenAI account | `list(string)` | n/a | yes |
| <a name="input_openai_model"></a> [openai\_model](#input\_openai\_model) | Model configuration for OpenAI deployment | <pre>object({<br/>    model      = string<br/>    version    = string<br/>    deploytype = string<br/>    capacity   = number<br/>  })</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_azurerm_user_assigned_identity_id"></a> [azurerm\_user\_assigned\_identity\_id](#input\_azurerm\_user\_assigned\_identity\_id) | The User Assigned Identity Resource ID to be associated with the APIM instance | `string` | `""` | no |
| <a name="input_identity_type"></a> [identity\_type](#input\_identity\_type) | The type of Managed Identity used for the APIM instance. Possible values are: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned, None | `string` | `"SystemAssigned"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cognitive_account_endpoints"></a> [cognitive\_account\_endpoints](#output\_cognitive\_account\_endpoints) | 各 Cognitive アカウントのエンドポイント URL |
| <a name="output_cognitive_account_ids"></a> [cognitive\_account\_ids](#output\_cognitive\_account\_ids) | 各 OpenAI Cognitive アカウントの ID |
| <a name="output_cognitive_account_names"></a> [cognitive\_account\_names](#output\_cognitive\_account\_names) | 各 Cognitive アカウントの名前 |
| <a name="output_deployment_ids"></a> [deployment\_ids](#output\_deployment\_ids) | 各 Cognitive Deployment のリソース ID |
| <a name="output_deployment_names"></a> [deployment\_names](#output\_deployment\_names) | 各 Cognitive Deployment の名前 |
| <a name="output_rai_policy_names"></a> [rai\_policy\_names](#output\_rai\_policy\_names) | 各 RAI ポリシーの名前 |
<!-- END_TF_DOCS -->