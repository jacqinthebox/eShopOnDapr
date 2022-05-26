resource "random_password" "sa_password" {
  length = 32
  special = true
}

resource "azurerm_mssql_server" "server" {
  name                         = var.sql_server_name == null ? "${var.prefix}-sqlsrv" : var.sql_server_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  version                      = var.sql_version
  tags  = var.tags

  identity {
    type = var.identity_type
    identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
  }

  azuread_administrator {
    login_username = var.sql_aad_admin_login_username
    object_id = var.sql_aad_admin_object_id
    azuread_authentication_only = false
  }

  administrator_login          = var.sa_administrator_login == null ? "${var.prefix}-dbadmin" : var.sa_administrator_login
  administrator_login_password = random_password.sa_password.result
}

//allow the kube subnet
resource "azurerm_mssql_virtual_network_rule" "main" {
  name                = "sqlserver-vnet-rule"
  subnet_id           = var.vnet_rule_subnet_id
  server_id           = azurerm_mssql_server.server.id
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name                = "allow-azure-services"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
  server_id           = azurerm_mssql_server.server.id
}

resource "azurerm_mssql_firewall_rule" "allow_extra" {
  for_each = { for rule in var.sql_firewall_rules : rule.name => rule }
  name = each.key
  server_id = azurerm_mssql_server.server.id
  start_ip_address = each.value.start_ip_address
  end_ip_address = each.value.end_ip_address
}

resource "azurerm_mssql_database" "database" {
  for_each = { for db in var.databases : db.name => db }
  name                = each.key
  sku_name = each.value.sku_name
  license_type = each.value.license_type
  zone_redundant = each.value.zone_redundant
  server_id           = azurerm_mssql_server.server.id
}