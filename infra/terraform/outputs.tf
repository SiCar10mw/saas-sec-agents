output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "container_app_fqdn" {
  value = try(azurerm_container_app.orchestrator.ingress[0].fqdn, null)
}

output "servicebus_namespace" {
  value = azurerm_servicebus_namespace.main.name
}

output "key_vault_name" {
  value = azurerm_key_vault.main.name
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "evidence_containers" {
  value = sort(keys(azurerm_storage_container.evidence))
}
