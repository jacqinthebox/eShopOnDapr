output "name" {
  description = "Resource group name"
  value       = azurerm_resource_group.rg.name
}

output "rg_location" {
  description = "Resource group location"
  value       = azurerm_resource_group.rg.location
}