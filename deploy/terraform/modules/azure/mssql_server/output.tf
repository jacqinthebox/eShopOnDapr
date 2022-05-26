
output "sqlserver_name" {
  description = "The sqlserver name"
  value       = azurerm_mssql_server.server.name
}

output "sql_msi_principal_id" {
  description = "The sqlserver msi principal id"
  value       = azurerm_mssql_server.server.identity.0.principal_id
}

output "sql_server_sa_password" {
  description = "The sqlserver sa password"
  sensitive = true
  value       = azurerm_mssql_server.server.administrator_login_password
}

output "sql_server_sa_login" {
  description = "The sqlserver sa password"
  sensitive = true
  value       = azurerm_mssql_server.server.administrator_login
}
