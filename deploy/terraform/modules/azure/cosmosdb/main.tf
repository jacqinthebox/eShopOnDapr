
resource "azurerm_cosmosdb_account" "account" {
  name                = var.cosmosdb_account_name == null ? "${var.prefix}-cosmosdb" : var.cosmosdb_account_name
  resource_group_name = var.resource_group_name
  offer_type = "Standard" #this is the only choice
  kind = var.cosmosdb_kind

  consistency_policy {
    consistency_level = var.cosmosdb_consistency_policy
  }

  geo_location {
    location = var.location
    failover_priority = 0
    zone_redundant = false
  }
  location = var.location
}

resource "azurerm_cosmosdb_sql_database" "db" {
  name                = var.cosmosdb_db_name == null ? "${var.prefix}-cosmosdb" : var.cosmosdb_db_name
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.account.name
}

resource "azurerm_cosmosdb_sql_container" "collection" {
  name                = var.cosmosdb_sql_container_name == null ? "${var.prefix}-container" : var.cosmosdb_sql_container_name
  resource_group_name   = var.resource_group_name
  account_name          = azurerm_cosmosdb_account.account.name
  database_name         = azurerm_cosmosdb_sql_database.db.name
  partition_key_path    = var.partition_key_path
}
