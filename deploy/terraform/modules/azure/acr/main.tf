
resource "azurerm_container_registry" "acr" {
  name = try(replace("${var.prefix}containerregistry","-",""),var.acr_name)
  resource_group_name = var.resource_group_name
  location            =var.location
  sku                 = var.acr_sku
  admin_enabled       = var.admin_enabled
  tags = var.tags
}
