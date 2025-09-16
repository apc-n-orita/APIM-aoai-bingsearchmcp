
output "name" {
  value = azapi_resource.function.name
}

output "uri" {
  value = "https://${azapi_resource.function.output.properties.defaultHostName}"
}

output "identity_principal_id" {
  value = azapi_resource.function.output.identity.principalId

}

output "masterkey" {
  value = azapi_resource_action.functionapp_host_keys.output.masterKey
}
