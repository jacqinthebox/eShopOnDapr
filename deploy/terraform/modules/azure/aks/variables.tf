variable "prefix" {
  type = string
  description = "An identifier for resources to use with the cluster"
  default = null
}

variable "cluster_name" {
  type = string
  description = "The name of the kubernetes cluster. Only required when prefix is not set."
  default = null
}

variable "node_resource_group" {
  type = string
  description = "The name of the resource group to host the aks resources. Only required when prefix is not set."
  default = null
}

variable "tags" {
  type = map(string)
  description = "A map of key value pairs to tag resources"
}

variable "local_account_disabled" {
  type = bool
  description = "Enable or disable the local account"
}

variable "location" {
  type = string
  description = "The location for the resources"
  default = "westeurope"
}

variable "vnet_subnet_id" {
  type = string
  description = "The subnet id for the cluster"
}
variable "loganalytics_workspace_id" {
  type = string
  description = "The loganalytics workspace id for the cluster"
}

variable "kube_resource_group_name" {
  type        = string
  description = "The resource group for the kubernetes cluster."
}

variable "dns_prefix" {
  type        = string
  description = "(Optional) DNS prefix specified when creating the managed cluster. Changing this forces a new resource to be created."
}

variable "default_node_pool_name" {
  default = "systempool"
}

variable "default_node_pool_size" {
  description = "size like Standard_E2_v4, Standard_B4ms, Standard_D2s_v3, Standard_B2ms"
  default = "Standard_B2ms"
}
variable "default_node_pool_zones" {
  default = ["1","2","3"]
}

variable "default_node_pool_name_enable_autoscaling" {
  default = false
}

variable "default_node_pool_kubelet_disk_type" {
  description = "Can be OS or Tempory. Default OS"
  default = "Temporary"
}

variable "default_node_pool_max_pods" {
  default = 30
}

variable "default_node_pool_os_disk_size_gb" {
  default = 128
}

variable "default_node_pool_os_disk_type" {
  default = null
}

variable "default_node_pool_autoscaling_max_count" {
  default = 3
}
variable "default_node_pool_autoscaling_min_count" {
  default = 1
}
variable "default_node_pool_autoscaling_node_count" {
  default = 1
}

variable "default_node_pool_vnet_subnet_id" {
  type = string
  description = "The object id of the subnet"
}

variable "public_ssh_key" {
  type = string
  description = "The path to a public ssh key file"
  default = ""
}
variable "node_admin_username" {
  default = "node-admin"
}


variable "api_server_authorized_ip_ranges" {
  type = list(string)
  description = "IP addresses to allow to interact with the kubernetes api"
}

variable "private_cluster_enabled" {
  default = false
}

variable "sku_tier" {
  description = "The SKU Tier that should be used for this Kubernetes Cluster. Possible values are Free and Paid (which includes the Uptime SLA). Defaults to Free."
  default = "Free"
}

variable "network_profile" {
  description = "The network profile for the cluster"
  type = object({
    network_plugin = string
    network_mode = string
    network_policy  = string
    dns_service_ip     = string
    docker_bridge_cidr = string
    outbound_type      = string
    //pod_cidr           = string
    service_cidr       = string
    load_balancer_sku  = string
    //load_balancer_profile {}
    //nat_gateway_profile {}
  })
  default = {
    network_plugin = "azure"
    network_mode   = "transparent"
    network_policy = "azure"
    dns_service_ip = "10.2.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    outbound_type      = "loadBalancer"
    service_cidr       = "10.2.0.0/16"
    load_balancer_sku  = "standard" #required for availability zones
  }
}

variable "tenant_id" {
  type = string
  description = "The tenant id of the Azure Active Directory"
  #default = "63060cb1-0960-4615-8769-b110040fa763"
}

/*
variable "admin_group_object_ids" {
  description = "The object id's of the aks admin group"
  default = ["e1ad18a1-95ec-4cc4-8eb4-61a6aeecff1f"]
}
*/

variable "admin_group_object_ids" {
  type = list(string)
  description = "The object id of the aks admin group"
}

variable "default_node_pool_only_critical_addons_enabled" {
  default = false
}

variable "azurerm_container_registry_id" {
  type = string
  description = "Required when azurerm_container_registry_enabled is true."
  default = null
}

//only create this when there is an azurerm container registry specified
variable "azurerm_container_registry_enabled" {
  description = "Required. Set to true when there is an azurerm container registry you want link"
  type = bool
}

variable "azure_policy_enabled" {
  default = false
}

variable "http_application_routing_enabled" {
  default = false
}