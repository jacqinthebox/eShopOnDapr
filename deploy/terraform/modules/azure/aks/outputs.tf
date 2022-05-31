output "kube_cluster_id" {
  value = azurerm_kubernetes_cluster.kube.id
}

output "kube_cluster_location" {
  value = azurerm_kubernetes_cluster.kube.location
}

output "kube_cluster_node_group" {
  value = azurerm_kubernetes_cluster.kube.node_resource_group
}


output "kube_cluster_resource_group" {
  value = azurerm_kubernetes_cluster.kube.resource_group_name
}


output "kube_cluster_name" {
  value = azurerm_kubernetes_cluster.kube.name
}

output "private_ssh_key" {
  value = module.ssh-key.private_ssh_key
  sensitive = true
}

output "public_ssh_key" {
  value = module.ssh-key.public_ssh_key
}