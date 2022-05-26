output "client_id" {
  value = azurerm_user_assigned_identity.main.client_id
}

output "principal_id" {
  value = azurerm_user_assigned_identity.main.principal_id
}

output "identity_name" {
  value = azurerm_user_assigned_identity.main.name
}

output "tenant_id" {
  value = azurerm_user_assigned_identity.main.tenant_id
}
