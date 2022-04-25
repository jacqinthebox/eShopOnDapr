
resource "azurerm_servicebus_namespace" "servicebus" {
  name                = var.sb_namespace_name == null ? "${var.prefix}-sb-namespace" : var.sb_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
}



//output connectionString string = 'Endpoint=sb://${serviceBus.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${listKeys('${serviceBus.id}/AuthorizationRules/RootManageSharedAccessKey', serviceBus.apiVersion).primaryKey}'
