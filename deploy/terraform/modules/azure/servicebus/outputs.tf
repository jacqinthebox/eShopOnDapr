output "name" {
  value = azurerm_servicebus_namespace.servicebus.name
}

output "primary" {
  value = azurerm_servicebus_namespace.servicebus.default_primary_connection_string
  sensitive = true
}