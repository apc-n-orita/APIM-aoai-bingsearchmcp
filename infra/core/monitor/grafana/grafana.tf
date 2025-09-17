terraform {
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
  }
}

resource "azurerm_dashboard_grafana" "main" {
  name                              = var.name
  resource_group_name               = var.rg_name
  location                          = var.location
  grafana_major_version             = var.grafana_major_version
  deterministic_outbound_ip_enabled = var.deterministic_outbound_ip_enabled
  api_key_enabled                   = var.api_key_enabled
  public_network_access_enabled     = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags

  dynamic "azure_monitor_workspace_integrations" {
    for_each = var.azure_monitor_workspace_integrations
    content {
      resource_id = azure_monitor_workspace_integrations.value.resource_id
    }
  }
}

resource "azurerm_role_assignment" "admin_grafana_access" {
  scope                = azurerm_dashboard_grafana.main.id
  role_definition_name = "Grafana Admin"
  principal_id         = var.object_id
}

resource "azurerm_role_assignment" "grafana_monitoring_reader" {
  scope                = "/subscriptions/${var.subscription_id}"
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.main.identity[0].principal_id
}
