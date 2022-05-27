
output nodepools {
  description = "Generated subnet ids map"
  value       = { for pool in azurerm_kubernetes_cluster_node_pool.nodepool : pool.name => pool.id }
}
