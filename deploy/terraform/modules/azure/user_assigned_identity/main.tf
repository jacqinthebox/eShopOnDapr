resource "azurerm_user_assigned_identity" "main" {
  resource_group_name = var.identity_resourcegroup_name
  location            = var.location
  name = var.identity_name
}