output "cosmosdb_account_name" {
  value = azurerm_cosmosdb_account.account.name
}

output "cosmosdb_db_name" {
  value = azurerm_cosmosdb_sql_database.db.name
}

output "cosmosdb_url" {
  value = azurerm_cosmosdb_account.account.endpoint
}
