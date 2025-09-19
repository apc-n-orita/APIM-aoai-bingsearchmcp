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

resource "azurerm_cognitive_account" "openai" {
  for_each              = toset(var.openai_locations)
  name                  = "${var.name}-${substr(each.value, 0, 3)}"
  location              = each.value
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = "S0"
  custom_subdomain_name = "${var.name}-${each.value}"

  identity {
    type         = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" || var.identity_type == "SystemAssigned, UserAssigned" ? [var.azurerm_user_assigned_identity_id] : null
  }
}

resource "azurerm_cognitive_account_rai_policy" "contentpolicy" {
  for_each             = toset(var.openai_locations)
  name                 = "${var.name}-${substr(each.value, 0, 2)}-rai-policy"
  cognitive_account_id = azurerm_cognitive_account.openai[each.value].id
  base_policy_name     = "Microsoft.DefaultV2"
  mode                 = "Default"

  content_filter {
    name               = "Violence"
    filter_enabled     = true
    block_enabled      = true
    severity_threshold = "Low"
    source             = "Prompt"
  }

  content_filter {
    name               = "Hate"
    filter_enabled     = true
    block_enabled      = true
    severity_threshold = "Low"
    source             = "Prompt"
  }

  content_filter {
    name               = "Sexual"
    filter_enabled     = true
    block_enabled      = true
    severity_threshold = "Low"
    source             = "Prompt"
  }

  content_filter {
    name               = "Selfharm"
    filter_enabled     = true
    block_enabled      = true
    severity_threshold = "Low"
    source             = "Prompt"
  }


  content_filter {
    name               = "Violence"
    filter_enabled     = true
    block_enabled      = true
    severity_threshold = "Low"
    source             = "Completion"
  }

  content_filter {
    name               = "Hate"
    filter_enabled     = true
    block_enabled      = true
    severity_threshold = "Low"
    source             = "Completion"
  }

  content_filter {
    name               = "Sexual"
    filter_enabled     = true
    block_enabled      = true
    severity_threshold = "Low"
    source             = "Completion"
  }

  content_filter {
    name               = "Selfharm"
    filter_enabled     = true
    block_enabled      = true
    severity_threshold = "Low"
    source             = "Completion"
  }
}
#resource "azapi_resource" "contentpolicy" {
#  for_each  = toset(var.openai_locations)
#  name      = "${var.name}-${substr(each.value, 0, 3)}-rai-policy"
#  type      = "Microsoft.CognitiveServices/accounts/raiPolicies@2024-10-01"
#  parent_id = azurerm_cognitive_account.openai[each.value].id
#
#  body = {
#    properties = {
#      basePolicyName = "Microsoft.DefaultV2"
#      contentFilters = var.content_filters
#      mode           = "Default"
#    }
#  }
#}


resource "azurerm_cognitive_deployment" "deployment" {
  for_each             = toset(var.openai_locations)
  name                 = "${var.openai_model.model}_${var.openai_model.version}"
  cognitive_account_id = azurerm_cognitive_account.openai[each.value].id

  model {
    format  = "OpenAI"
    name    = var.openai_model.model
    version = var.openai_model.version
  }

  rai_policy_name = azurerm_cognitive_account_rai_policy.contentpolicy[each.value].name

  sku {
    name     = var.openai_model.deploytype
    capacity = var.openai_model.capacity
  }

  version_upgrade_option = "NoAutoUpgrade"
}

resource "azurerm_monitor_diagnostic_setting" "openai" {
  for_each                   = toset(var.openai_locations)
  name                       = "send-to-law"
  target_resource_id         = azurerm_cognitive_account.openai[each.value].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
