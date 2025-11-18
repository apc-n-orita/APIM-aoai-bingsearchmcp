terraform {
  required_providers {
    azurerm = {
      version = "~>4.42.0"
      source  = "hashicorp/azurerm"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.0.0"
    }
  }
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azapi_resource" "ai_foundry" {
  type                      = "Microsoft.CognitiveServices/accounts@2025-06-01"
  name                      = var.name
  parent_id                 = data.azurerm_resource_group.rg.id
  location                  = var.location
  schema_validation_enabled = false
  tags                      = var.tags
  body = {
    kind = "AIServices",
    sku = {
      name = "S0"
    }
    identity = {
      type = "SystemAssigned"
    }

    properties = {
      # Support both Entra ID and API Key authentication for underlining Cognitive Services account
      disableLocalAuth = var.disable_local_auth

      # Specifies that this is an AI Foundry resource
      allowProjectManagement = true

      # Set custom subdomain name for DNS names created for this Foundry resource
      customSubDomainName = var.name

      # Network-related controls
      # Disable public access but allow Trusted Azure Services exception
      #publicNetworkAccess = "Disabled"
      #networkAcls = {
      #  defaultAction = "Allow"
      #}

      # Enable VNet injection for Standard Agents
      #networkInjections = [
      #  {
      #    scenario                   = "agent"
      #    subnetArmId                = var.subnet_id_agent
      #    useMicrosoftManagedNetwork = false
      #  }
      #]
    }
  }
}

resource "azurerm_cognitive_deployment" "deployment" {
  name                 = "${var.ai_model.model}_${var.ai_model.version}"
  cognitive_account_id = azapi_resource.ai_foundry.id

  model {
    format  = var.ai_model.format
    name    = var.ai_model.model
    version = var.ai_model.version
  }

  sku {
    name     = var.ai_model.deploytype
    capacity = var.ai_model.capacity
  }
  version_upgrade_option = "NoAutoUpgrade"

  depends_on = [
    azapi_resource.ai_foundry
  ]
}


resource "azurerm_monitor_diagnostic_setting" "ai_foundry" {
  name                       = "send-to-law"
  target_resource_id         = azapi_resource.ai_foundry.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
