output "sql_msi_principal_id" {
  value = module.mssql_server.sql_msi_principal_id
}

output "sql_sa_password" {
  value = module.mssql_server.sql_server_sa_password
  sensitive = true
}

output "sql_sa_login" {
  sensitive = true
  value = module.mssql_server.sql_server_sa_login
}


output "servicebus_name" {
  value = module.service_bus.servicebus_name
}

output "servicebus_primary_connstring" {
  value = module.service_bus.servicebus_primary_connstring
  sensitive = true
}

output "servicebus_namespace_id" {
  value = module.service_bus.servicebus_namespace_id
}

output "servicebus_identity_tenant_id" {
  value = module.service_bus.servicebus_identity_tenant_id
}

output "servicebus_identity_principal_id" {
  value = module.service_bus.servicebus_identity_principal_id
}

output "user-assigned_identity_service_bus_principal_id" {
  value = module.service_bus_user_assigned_identity.principal_id
}

output "user-assigned_identity_service_bus_client_id" {
  value = module.service_bus_user_assigned_identity.client_id
}

output "user-assigned_identity_sql_principal_id" {
  value = module.sql_server_user_assigned_identity.principal_id
}

output "user-assigned_identity_sql_client_id" {
  value = module.sql_server_user_assigned_identity.client_id
}