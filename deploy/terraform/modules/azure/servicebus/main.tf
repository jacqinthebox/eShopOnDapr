
resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  name                = var.servicebus_namespace_name == null ? "${var.prefix}-sb-ns" : var.servicebus_namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags

  identity {
    type         = var.servicebus_namespace_identity_type
    identity_ids = var.servicebus_namespace_identity_ids
  }
}

resource "azurerm_servicebus_queue" "servicebus_queue" {
  name                  = var.servicebus_queue_name
  enable_partitioning   = true
  namespace_id        = azurerm_servicebus_namespace.servicebus_namespace.id
}


//output connectionString string = 'Endpoint=sb://${serviceBus.name}.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=${listKeys('${serviceBus.id}/AuthorizationRules/RootManageSharedAccessKey', serviceBus.apiVersion).primaryKey}'
