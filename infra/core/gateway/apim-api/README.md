<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~>1.2.24 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.97.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.97.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_api_management_api.api](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api) | resource |
| [azurerm_api_management_api_diagnostic.diagnostics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic) | resource |
| [azurerm_api_management_api_policy.policies](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_policy) | resource |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_backend_url"></a> [api\_backend\_url](#input\_api\_backend\_url) | Absolute URL of the backend service implementing this API. | `string` | n/a | yes |
| <a name="input_api_display_name"></a> [api\_display\_name](#input\_api\_display\_name) | The Display Name of the API | `string` | n/a | yes |
| <a name="input_api_management_logger_id"></a> [api\_management\_logger\_id](#input\_api\_management\_logger\_id) | The name of the resource application insights | `string` | n/a | yes |
| <a name="input_api_name"></a> [api\_name](#input\_api\_name) | Resource name to uniquely identify this API within the API Management service instance | `string` | n/a | yes |
| <a name="input_api_path"></a> [api\_path](#input\_api\_path) | Relative URL uniquely identifying this API and all of its resource paths within the API Management service instance. It is appended to the API endpoint base URL specified during the service instance creation to form a public URL for this API. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group to deploy resources into | `string` | n/a | yes |
| <a name="input_web_front_end_url"></a> [web\_front\_end\_url](#input\_web\_front\_end\_url) | The url of the web | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_SERVICE_API_URI"></a> [SERVICE\_API\_URI](#output\_SERVICE\_API\_URI) | n/a |
<!-- END_TF_DOCS -->