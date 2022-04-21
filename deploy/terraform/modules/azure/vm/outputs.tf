output "vm_ip" {
  description = ""
  value       = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "vm_username" {
  description = "vm username"
  value       = azurerm_linux_virtual_machine.vm.admin_username
}

output "vm_password" {
  description = "vm admin password"
  value       = azurerm_linux_virtual_machine.vm.admin_password
  sensitive = true
}

output "tls_private_key" {
  value = tls_private_key.ssh_config.private_key_pem
  sensitive = true
}

output "tls_public_key" {
  value = tls_private_key.ssh_config.public_key_pem
}