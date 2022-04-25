output "public_ssh_key" {
  description = "The public ssh key (only output a generated ssh public key)."
  value       =  tls_private_key.ssh.public_key_openssh
}

output "private_ssh_key" {
  description = "The private ssh key."
  value       =  tls_private_key.ssh.private_key_pem
  sensitive = true
}