output "cosmos_sql_account_name" {
  value = azurerm_cosmosdb_account.sql.name
}

output "cosmos_sql_database_name" {
  value = azurerm_cosmosdb_sql_database.db.name
}

output "cosmos_sql_container_name" {
  value = azurerm_cosmosdb_sql_container.container.name
}

output "cosmos_sql_endpoint" {
  value = azurerm_cosmosdb_account.sql.endpoint
}
