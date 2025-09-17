<!-- BEGIN_TF_DOCS -->

## Requirements

| Name                                                               | Version  |
| ------------------------------------------------------------------ | -------- |
| <a name="requirement_azuread"></a> [azuread](#requirement_azuread) | ~>3.5.0  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement_azurerm) | ~>4.42.0 |
| <a name="requirement_random"></a> [random](#requirement_random)    | ~>3.7.0  |

## Providers

| Name                                                         | Version  |
| ------------------------------------------------------------ | -------- |
| <a name="provider_azuread"></a> [azuread](#provider_azuread) | ~>3.5.0  |
| <a name="provider_azurerm"></a> [azurerm](#provider_azurerm) | ~>4.42.0 |
| <a name="provider_random"></a> [random](#provider_random)    | ~>3.7.0  |

## Resources

| Name                                                                                                                                                                                             | Type        |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------- |
| [azuread_application.entra_app](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application)                                                                     | resource    |
| [azuread_application_federated_identity_credential.fic](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_federated_identity_credential)               | resource    |
| [azurerm_api_management_api.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api)                                                           | resource    |
| [azurerm_api_management_api_diagnostic.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_diagnostic)                                     | resource    |
| [azurerm_api_management_api_operation.oauth_authorize](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                             | resource    |
| [azurerm_api_management_api_operation.oauth_callback](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                              | resource    |
| [azurerm_api_management_api_operation.oauth_consent_get](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                           | resource    |
| [azurerm_api_management_api_operation.oauth_consent_post](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                          | resource    |
| [azurerm_api_management_api_operation.oauth_metadata_get](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                          | resource    |
| [azurerm_api_management_api_operation.oauth_metadata_options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                      | resource    |
| [azurerm_api_management_api_operation.oauth_register](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                              | resource    |
| [azurerm_api_management_api_operation.oauth_register_options](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                      | resource    |
| [azurerm_api_management_api_operation.oauth_token](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation)                                 | resource    |
| [azurerm_api_management_api_operation_policy.oauth_authorize_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy)        | resource    |
| [azurerm_api_management_api_operation_policy.oauth_callback_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy)         | resource    |
| [azurerm_api_management_api_operation_policy.oauth_consent_get_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy)      | resource    |
| [azurerm_api_management_api_operation_policy.oauth_consent_post_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy)     | resource    |
| [azurerm_api_management_api_operation_policy.oauth_metadata_get_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy)     | resource    |
| [azurerm_api_management_api_operation_policy.oauth_metadata_options_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource    |
| [azurerm_api_management_api_operation_policy.oauth_register_options_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy) | resource    |
| [azurerm_api_management_api_operation_policy.oauth_register_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy)         | resource    |
| [azurerm_api_management_api_operation_policy.oauth_token_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_operation_policy)            | resource    |
| [azurerm_api_management_api_policy.oauth](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_api_policy)                                             | resource    |
| [azurerm_api_management_named_value.EncryptionIV](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                                    | resource    |
| [azurerm_api_management_named_value.EncryptionKey](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                                   | resource    |
| [azurerm_api_management_named_value.apim_gateway_url](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                                | resource    |
| [azurerm_api_management_named_value.entra_id_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                              | resource    |
| [azurerm_api_management_named_value.entra_id_fic_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                          | resource    |
| [azurerm_api_management_named_value.entra_id_tenant_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                              | resource    |
| [azurerm_api_management_named_value.mcp_client_id](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                                   | resource    |
| [azurerm_api_management_named_value.mcp_server_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                                 | resource    |
| [azurerm_api_management_named_value.oauth_callback_uri](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                              | resource    |
| [azurerm_api_management_named_value.oauth_scopes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_named_value)                                    | resource    |
| [random_bytes.IV](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes)                                                                                          | resource    |
| [random_bytes.Key](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/bytes)                                                                                         | resource    |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management)                                                                 | data source |

## Inputs

| Name                                                                                                               | Description                                                              | Type     | Default | Required |
| ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------ | -------- | ------- | :------: |
| <a name="input_api_management_logger_id"></a> [api_management_logger_id](#input_api_management_logger_id)          | The resource ID of the Application Insights logger for APIM diagnostics. | `string` | n/a     |   yes    |
| <a name="input_apim_service_name"></a> [apim_service_name](#input_apim_service_name)                               | The name of the API Management service                                   | `string` | n/a     |   yes    |
| <a name="input_azureuser_object_id"></a> [azureuser_object_id](#input_azureuser_object_id)                         | The object ID of the Azure user.                                         | `string` | n/a     |   yes    |
| <a name="input_entra_app_display_name"></a> [entra_app_display_name](#input_entra_app_display_name)                | The display name of the Entra application.                               | `string` | n/a     |   yes    |
| <a name="input_entra_app_tenant_id"></a> [entra_app_tenant_id](#input_entra_app_tenant_id)                         | The Entra application's tenant ID (entraApp.outputs.entraAppTenantId)    | `string` | n/a     |   yes    |
| <a name="input_entra_app_uami_client_id"></a> [entra_app_uami_client_id](#input_entra_app_uami_client_id)          | The client ID of the user-assigned managed identity for Entra app.       | `string` | n/a     |   yes    |
| <a name="input_entra_app_uami_principal_id"></a> [entra_app_uami_principle_id](#input_entra_app_uami_principle_id) | The principal ID of the user-assigned managed identity.                  | `string` | n/a     |   yes    |
| <a name="input_resource_group_name"></a> [resource_group_name](#input_resource_group_name)                         | n/a                                                                      | `any`    | n/a     |   yes    |

## Outputs

| Name                                                                                         | Description |
| -------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_api_name"></a> [api_name](#output_api_name)                                  | n/a         |
| <a name="output_entra_app_id"></a> [entra_app_id](#output_entra_app_id)                      | n/a         |
| <a name="output_entra_app_tenant_id"></a> [entra_app_tenant_id](#output_entra_app_tenant_id) | n/a         |
| <a name="output_oauth_api_id"></a> [oauth_api_id](#output_oauth_api_id)                      | n/a         |

<!-- END_TF_DOCS -->
