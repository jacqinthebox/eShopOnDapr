output "servicebus_name" {
  value = azurerm_servicebus_namespace.servicebus_namespace.name
}

output "servicebus_namespace_id" {
  value = azurerm_servicebus_namespace.servicebus_namespace.id
}

output "servicebus_primary_connstring" {
  value = azurerm_servicebus_namespace.servicebus_namespace.default_primary_connection_string
  sensitive = true
}

output "servicebus_identity_tenant_id" {
  value = azurerm_servicebus_namespace.servicebus_namespace.identity[0].tenant_id
}

output "servicebus_identity_principal_id" {
  value = azurerm_servicebus_namespace.servicebus_namespace.identity[0].principal_id
}

