
locals {
  insights_applications_files = [
    { filename = "insights_applications_failures_dependencies.json", title = "Failures - Dependencies", short = "faildep" },
    { filename = "insights_applications_failures_exceptions.json", title = "Failures - Exceptions", short = "failexc" },
    { filename = "insights_applications_failures_operations.json", title = "Failures - Operations", short = "failop" },
    { filename = "insights_applications_overview.json", title = "Overview", short = "overview" },
    { filename = "insights_applications_performance_dependencies.json", title = "Performance - Dependencies", short = "perfdep" },
  { filename = "insights_applications_performance_operations.json", title = "Performance - Operations", short = "perfop" }]
}
resource "grafana_folder" "main" {
  title = var.rg_name
}

resource "grafana_dashboard" "ai_api" {
  folder = grafana_folder.main.id
  config_json = templatefile("${path.module}/files/ai_api.json",
    {
      uid             = "ai-api"
      title           = "AI API"
      rg_name         = var.rg_name
      subscription_id = var.subscription_id
      appinsight_name = var.apim_appinsight_name
    }
  )

}

resource "grafana_dashboard" "ai_foundry" {
  for_each = { for resource in var.ai_foundry_resources : resource.name => resource }
  folder   = grafana_folder.main.id
  config_json = templatefile("${path.module}/files/ai_foundry.json",
    {
      uid             = lower(each.value.name)
      title           = "${upper(each.value.name)}"
      region          = each.value.location
      rg_name         = var.rg_name
      resource_name   = each.value.name
      subscription_id = var.subscription_id
    }
  )
}

resource "grafana_dashboard" "aoai" {
  for_each = { for resource in var.openai_resources : resource.name => resource }
  folder   = grafana_folder.main.id
  config_json = templatefile("${path.module}/files/ai_foundry.json",
    {
      uid             = lower(each.value.name)
      title           = "${upper(each.value.name)}"
      region          = each.value.location
      rg_name         = var.rg_name
      resource_name   = each.value.name
      subscription_id = var.subscription_id
    }
  )
}


resource "grafana_dashboard" "apim" {
  folder = grafana_folder.main.id
  config_json = templatefile("${path.module}/files/apim.json",
    {
      uid             = lower(var.apim_name)
      title           = upper(var.apim_name)
      rg_name         = var.rg_name
      appinsight_name = var.apim_appinsight_name
      subscription_id = var.subscription_id
      apim_name       = var.apim_name
      law_name        = var.law_name
    }
  )
}

resource "grafana_dashboard" "apim_appi" {
  for_each = { for file in local.insights_applications_files : file.filename => file }
  folder   = grafana_folder.main.id
  config_json = templatefile("${path.module}/files/${each.value.filename}",
    {
      uid             = "${lower(var.apim_appinsight_name)}${lower(each.value.short)}"
      title           = "${upper(var.apim_appinsight_name)}_${each.value.title}"
      rg_name         = var.rg_name
      appinsight_name = var.apim_appinsight_name
      subscription_id = var.subscription_id
    }
  )
}

resource "grafana_dashboard" "apim_func" {
  for_each = { for file in local.insights_applications_files : file.filename => file }
  folder   = grafana_folder.main.id
  config_json = templatefile("${path.module}/files/${each.value.filename}",
    {
      uid             = "${lower(var.func_appinsight_name)}${lower(each.value.short)}"
      title           = "${upper(var.func_appinsight_name)}_${each.value.title}"
      rg_name         = var.rg_name
      appinsight_name = var.func_appinsight_name
      subscription_id = var.subscription_id
    }
  )
}
