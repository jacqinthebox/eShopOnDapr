output "uai_client_id" {
  value = azurerm_user_assigned_identity.main.client_id
}

output "uai_principal_id" {
  value = azurerm_user_assigned_identity.main.principal_id
}
