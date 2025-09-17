<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7, < 2.0.0 |
| <a name="requirement_grafana"></a> [grafana](#requirement\_grafana) | ~>4.7.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_grafana"></a> [grafana](#provider\_grafana) | 4.7.1 |

## Resources

| Name | Type |
|------|------|
| [grafana_dashboard.ai_api](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.ai_foundry](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.aoai](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.apim](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.apim_appi](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_dashboard.apim_func](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_folder.main](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ai_foundry_resources"></a> [ai\_foundry\_resources](#input\_ai\_foundry\_resources) | AI Foundryリソース情報リスト | <pre>list(object({<br/>    name     = string<br/>    location = string<br/>  }))</pre> | n/a | yes |
| <a name="input_apim_appinsight_name"></a> [apim\_appinsight\_name](#input\_apim\_appinsight\_name) | APIM用Application Insights名 | `string` | n/a | yes |
| <a name="input_apim_name"></a> [apim\_name](#input\_apim\_name) | APIM名 | `string` | n/a | yes |
| <a name="input_func_appinsight_name"></a> [func\_appinsight\_name](#input\_func\_appinsight\_name) | Function App用Application Insights名 | `string` | n/a | yes |
| <a name="input_grafana_endpoint"></a> [grafana\_endpoint](#input\_grafana\_endpoint) | GrafanaのエンドポイントURL | `string` | n/a | yes |
| <a name="input_law_name"></a> [law\_name](#input\_law\_name) | Law用Application Insights名 | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The supported Azure location where the resource deployed | `string` | n/a | yes |
| <a name="input_openai_resources"></a> [openai\_resources](#input\_openai\_resources) | OpenAIリソース情報リスト | <pre>list(object({<br/>    name     = string<br/>    location = string<br/>  }))</pre> | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | Resource Group名 | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The subscription ID to deploy the resources | `string` | n/a | yes |
<!-- END_TF_DOCS -->