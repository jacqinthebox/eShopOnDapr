
resource "azurerm_virtual_network" "vnet" {
  address_space       = var.vnet_address_space
  location            = var.vnet_location
  name                = var.vnet_name == null ? "${var.prefix}-vnet" : var.vnet_name
  resource_group_name = var.vnet_resource_group
}

resource "azurerm_subnet" "subnet" {
  for_each = var.subnets
  name                 = each.key
  resource_group_name  = azurerm_virtual_network.vnet.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = each.value.service_endpoints
}