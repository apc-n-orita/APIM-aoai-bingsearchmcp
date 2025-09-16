output "cognitive_account_ids" {
  description = "各 OpenAI Cognitive アカウントの ID"
  value = {
    for key, account in azurerm_cognitive_account.openai :
    key => account.id
  }
}

output "cognitive_account_names" {
  description = "各 Cognitive アカウントの名前"
  value = {
    for key, account in azurerm_cognitive_account.openai :
    key => account.name
  }
}

output "cognitive_account_endpoints" {
  description = "各 Cognitive アカウントのエンドポイント URL"
  value = {
    for key, account in azurerm_cognitive_account.openai :
    key => account.endpoint
  }
}

output "rai_policy_names" {
  description = "各 RAI ポリシーの名前"
  value = {
    for key, policy in azurerm_cognitive_account_rai_policy.contentpolicy :
    key => policy.name
  }
}

output "deployment_names" {
  description = "各 Cognitive Deployment の名前"
  value = {
    for key, deployment in azurerm_cognitive_deployment.deployment :
    key => deployment.name
  }
}

output "deployment_ids" {
  description = "各 Cognitive Deployment のリソース ID"
  value = {
    for key, deployment in azurerm_cognitive_deployment.deployment :
    key => deployment.id
  }
}
