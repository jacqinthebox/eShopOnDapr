resource "null_resource" "register_az_features" {
  provisioner "local-exec" {
    command = <<EOT
      az feature register --namespace Microsoft.ContainerService -n AutoUpgradePreview
      az feature register --name EnablePodIdentityPreview --namespace Microsoft.ContainerService
      az provider register --name Microsoft.ContainerService
      az extension add --name aks-preview
      az extension update --name aks-preview
    EOT
  }
}

data "azurerm_kubernetes_service_versions" "current" {
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "kube" {
  name = try("${var.prefix}-cluster",var.cluster_name)
  location            = var.location
  resource_group_name = var.kube_resource_group_name
  dns_prefix          = try("${var.prefix}-aks",var.dns_prefix)

  default_node_pool {
    name    = var.default_node_pool_name
    vm_size = var.default_node_pool_size
    zones = var.default_node_pool_zones
    enable_auto_scaling = try(var.default_node_pool_name_enable_autoscaling, false)
    max_count = var.default_node_pool_autoscaling_max_count
    min_count = var.default_node_pool_autoscaling_min_count
    node_count = var.default_node_pool_autoscaling_node_count
    //enable_host_encryption
    //enable_node_public_ip
    //kubelet_config
    //linux_os_config
    //fips_enabled
    //kubelet_disk_type = try(var.default_node_pool_kubelet_disk_type, null)
    max_pods = var.default_node_pool_max_pods
    //node_public_ip_prefix_id
    //node_labels
    only_critical_addons_enabled = var.default_node_pool_only_critical_addons_enabled
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    os_disk_size_gb = var.default_node_pool_os_disk_size_gb
    os_disk_type = try(var.default_node_pool_os_disk_type, null)
    //os_sku
    //pod_subnet_id
    //type #always want a VMSS
    tags = var.tags
    //ultra_ssd_enabled
    //upgrade_settings {
    //  max_surge = ""
    //}
    vnet_subnet_id = var.vnet_subnet_id
  }

  //dns_prefix_private_cluster = ""
  //aci_connector_linux{}
  automatic_channel_upgrade = "patch" #Possible values are patch, rapid, node-image and stable. Omitting this field sets this value to none.
  //api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges
  //auto_scaler_profile {}

  azure_active_directory_role_based_access_control {
    managed = true
    tenant_id = var.tenant_id
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled = true
  }

  azure_policy_enabled = var.azure_policy_enabled
  //disk_encryption_set_id
  http_application_routing_enabled = var.http_application_routing_enabled
  //http_proxy_config

  /*
  An identity block supports the following:
  type - (Required) Specifies the type of Managed Service Identity that should be configured on this Kubernetes Cluster. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both).
  identity_ids - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster.
  NOTE:
  This is required when type is set to UserAssigned or SystemAssigned, UserAssigned.
  */
  identity {
    type = "SystemAssigned"
  }

  //ingress_application_gateway {}
  //kubelet_identity{}
  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version
  //linux_profile {}
  local_account_disabled = var.local_account_disabled
  //maintenance_window

  linux_profile {
    admin_username = var.node_admin_username
    ssh_key {
      # remove any new lines using the replace interpolation function
      key_data = replace(var.public_ssh_key == "" ? module.ssh-key.public_ssh_key : var.public_ssh_key, "\n", "")
    }
  }

  network_profile {
    network_plugin     = var.network_profile.network_plugin # by default set to azure
    network_mode       = var.network_profile.network_mode
    network_policy     = var.network_profile.network_policy
    dns_service_ip     = var.network_profile.dns_service_ip # 10.2.0.10
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr # 172.17.0.1/16
    outbound_type      = var.network_profile.outbound_type #loadBalancer
    //pod_cidr           = var.network_profile_pod_cidr # only when using kubenet
    service_cidr       = var.network_profile.service_cidr # 10.2.0.0/16"
    load_balancer_sku  = var.network_profile.load_balancer_sku #standard or basic
    //load_balancer_profile {}
    //nat_gateway_profile {}
  }
  node_resource_group = try("${var.prefix}-cluster-nodes-rg",var.node_resource_group)
  oidc_issuer_enabled = false

  oms_agent{
    log_analytics_workspace_id=var.loganalytics_workspace_id
  }
  open_service_mesh_enabled = false
  private_cluster_enabled = var.private_cluster_enabled
  //private_dns_zone_id
  //private_cluster_fqdn_enabled
  public_network_access_enabled = true
  role_based_access_control_enabled = true

  # azure_keyvault_secrets_provider
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
  }
  sku_tier = var.sku_tier
  tags = var.tags
}

module "ssh-key" {
  source         = "../../global/ssh-key"
  public_ssh_key = var.public_ssh_key == "" ? "" : var.public_ssh_key
}

resource "azurerm_role_assignment" "acr_role" {
  count = var.azurerm_container_registry_enabled == true ? 1 : 0
  principal_id                     = azurerm_kubernetes_cluster.kube.kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = var.azurerm_container_registry_id
  skip_service_principal_aad_check = true
}
