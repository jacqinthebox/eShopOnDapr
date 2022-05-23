output "private_ssh_key" {
  value = module.kube.private_ssh_key
  sensitive = true
}

output "public_ssh_key" {
  value = module.kube.public_ssh_key
}

output "sql_msi_principal_id" {
  value = module.mssql_server.sql_msi_principal_id
}