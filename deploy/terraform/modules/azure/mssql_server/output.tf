
output "sqlserver_name" {
  description = "The sqlserver name"
  value       = azurerm_mssql_server.server.name
}

output "sql_msi_principal_id" {
  description = "The sqlserver msi principal id"
  value       = azurerm_mssql_server.server.identity.0.principal_id
}

