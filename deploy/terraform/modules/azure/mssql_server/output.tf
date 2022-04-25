output "admin_password" {
  description = "Password for admin on the sql server."
  value       = random_password.password.result
  sensitive   = true
}

output "db_username" {
  description = "Username for the sa account"
  value       = azurerm_mssql_server.server.administrator_login
}

output "sqlserver_name" {
  description = "The sqlserver name"
  value       = azurerm_mssql_server.server.name
}


