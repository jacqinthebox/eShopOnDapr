output "vnet_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The Name of the newly created vNet"
  value       = azurerm_virtual_network.vnet.name
}

output "vnet_location" {
  description = "The location of the newly created vNet"
  value       = azurerm_virtual_network.vnet.location
}

output "vnet_address_space" {
  description = "The address space of the newly created vNet"
  value       = azurerm_virtual_network.vnet.address_space
}

output "vnet_resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  value       = azurerm_virtual_network.vnet.resource_group_name
}

output subnet_ids {
  description = "Generated subnet ids map"
  value       = { for subnet in azurerm_subnet.subnet : subnet.name => subnet.id }
}