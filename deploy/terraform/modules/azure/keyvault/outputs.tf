output "vault_resource_group_name" {
  value = azurerm_key_vault.vault.resource_group_name
}

output "vault_id" {
  value = azurerm_key_vault.vault.id
}

output "vault_resource_group_uri" {
  value = azurerm_key_vault.vault.vault_uri
}
