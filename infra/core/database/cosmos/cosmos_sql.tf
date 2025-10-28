terraform {
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
  }
}

############################################################
# Cosmos DB Account (SQL API - Serverless)
############################################################
resource "azurerm_cosmosdb_account" "sql" {
  name                       = var.sql_account_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  offer_type                 = "Standard"
  kind                       = "GlobalDocumentDB" # SQL API
  tags                       = var.tags
  automatic_failover_enabled = false

  # Serverless capability
  capabilities { name = "EnableServerless" }

  # Consistency
  consistency_policy { consistency_level = "Session" }

  # Single region
  geo_location {
    location          = var.location
    failover_priority = 0
    zone_redundant    = false
  }

  # Attributes renamed per azurerm provider schema (3.x):
  # multiple_write_locations_enabled controls multi-region writes; keep false for serverless baseline.
  multiple_write_locations_enabled = false
  # automatic failover not needed single region; remove unsupported attr for provider version.
  public_network_access_enabled = var.public_network_access_enabled

  # NOTE: Free tierやanalytical store等の追加は要件次第で拡張可能
  lifecycle {
    ignore_changes = [capabilities] # Provider差分ノイズ抑制
  }
}

############################################################
# SQL Database
############################################################
resource "azurerm_cosmosdb_sql_database" "db" {
  name                = var.database_name
  resource_group_name = azurerm_cosmosdb_account.sql.resource_group_name
  account_name        = azurerm_cosmosdb_account.sql.name
  # serverlessなので throughput 指定なし (Autoscale/Manual省略)
}

############################################################
# SQL Container
############################################################
resource "azurerm_cosmosdb_sql_container" "container" {
  name                = var.container_name
  resource_group_name = azurerm_cosmosdb_account.sql.resource_group_name
  account_name        = azurerm_cosmosdb_account.sql.name
  database_name       = azurerm_cosmosdb_sql_database.db.name

  # Partition key paths must be an array per provider schema.
  partition_key_paths   = ["/clientId"]
  partition_key_version = 2
  partition_key_kind    = "Hash"

  indexing_policy {
    indexing_mode = "consistent"

    included_path {
      path = "/*"
    }
    excluded_path {
      path = "/\"_etag\"/?"
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "cosmos_sql" {
  name                           = "send-to-law"
  target_resource_id             = azurerm_cosmosdb_account.sql.id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = "Dedicated"

  # ログカテゴリ例: "DataPlaneRequests", "MongoRequests", "QueryRuntimeStatistics", "PartitionKeyStatistics", "ControlPlaneRequests"
  # 必要に応じて有効化カテゴリを調整
  enabled_log {
    category_group = "allLogs"
  }
}
