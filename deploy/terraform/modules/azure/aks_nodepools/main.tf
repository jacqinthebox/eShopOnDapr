resource "azurerm_kubernetes_cluster_node_pool" "nodepool" {
  lifecycle {
    ignore_changes = [
      node_count
    ]
  }

  for_each = var.additional_nodepools
  kubernetes_cluster_id = var.kubernetes_cluster_id
  name                  = each.value.name
  mode                  = each.value.mode
  node_count            = each.value.node_count
  vm_size               = each.value.vm_size
  zones                 = each.value.availability_zones
  max_pods              = each.value.max_pods #250
  os_disk_size_gb       = each.value.os_disk_size_gb #128
  node_taints           = each.value.taints
  node_labels           = each.value.labels
  enable_auto_scaling   = each.value.cluster_auto_scaling
  min_count             = each.value.cluster_auto_scaling_min_count
  max_count             = each.value.cluster_auto_scaling_max_count
  orchestrator_version  = var.orchestrator_version
  spot_max_price        = -1
  vnet_subnet_id        = var.vnet_subnet_id
  priority              = var.priority
  os_disk_type          = var.os_disk_type
}
