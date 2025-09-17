terraform {
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
  }
}
resource "azurerm_storage_account" "main" {
  name                     = var.name
  location                 = var.location
  resource_group_name      = var.resource_group_name
  tags                     = var.tags
  account_tier             = var.tier
  account_replication_type = var.replication_type
  #public_network_access_enabled = var.public_network_access == "Enabled" ? true : false
  shared_access_key_enabled = var.shared_access_key_enabled

  #network_rules {
  #  bypass         = var.network_acls.bypass
  #  default_action = var.network_acls.default_action
  #}
}

# ストレージアカウントの診断設定
# Blob サービスの診断設定
resource "azurerm_monitor_diagnostic_setting" "storage_blob_diagnostics" {
  name                       = "blob-diagnostics"
  target_resource_id         = "${azurerm_storage_account.main.id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}

# Table サービスの診断設定
resource "azurerm_monitor_diagnostic_setting" "storage_table_diagnostics" {
  name                       = "table-diagnostics"
  target_resource_id         = "${azurerm_storage_account.main.id}/tableServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}

# Queue サービスの診断設定
resource "azurerm_monitor_diagnostic_setting" "storage_queue_diagnostics" {
  name                       = "queue-diagnostics"
  target_resource_id         = "${azurerm_storage_account.main.id}/queueServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}


