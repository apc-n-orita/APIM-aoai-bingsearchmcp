############################################################
# Cosmos DB SQL Role Assignment (Built-in Data Contributor)
# Bicep元コード相当:
# name: guid(cosmosDbAccount.id, principalId, 'Cosmos DB Built-in Data Contributor')
# roleDefinitionId: {accountId}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002
# scope: cosmosDbAccount.id
# principalId: (外部入力)
############################################################

data "azurerm_api_management" "apim" {
  name                = var.api_management_name
  resource_group_name = var.resource_group_name

}
locals {
  built_in_data_contributor_definition_id = "00000000-0000-0000-0000-000000000002"
  # Deterministic name (Terraformリソース名は内部で管理されるためguid不要だが、displayName用にランダム化したい場合は別途)
  # Cosmos SQL Role Assignmentは providerリソース作成時に name 指定不要 (azurerm 3.97.1 時点)
}

resource "azurerm_cosmosdb_sql_role_assignment" "builtin_data_contributor" {
  account_name        = azurerm_cosmosdb_account.sql.name
  resource_group_name = azurerm_cosmosdb_account.sql.resource_group_name

  # Scope はアカウント全体
  scope = azurerm_cosmosdb_account.sql.id

  role_definition_id = "${azurerm_cosmosdb_account.sql.id}/sqlRoleDefinitions/${local.built_in_data_contributor_definition_id}"
  principal_id       = data.azurerm_api_management.apim.identity[0].principal_id
}

