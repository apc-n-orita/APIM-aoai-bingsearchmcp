output "ai_foundry_id" {
  description = "The resource ID of the AI foundry."
  value       = azapi_resource.ai_foundry.id
}

output "name" {
  description = "The name of the AI foundry."
  value       = azapi_resource.ai_foundry.name
}
