variable "priority" {
  default = "Regular"
}
variable "os_disk_type" {
  default = "Managed"
}
variable "kubernetes_cluster_id" {
  default = ""
}
variable "orchestrator_version" {
  default = ""
}
variable "vnet_subnet_id" {
  default = ""
}

variable "additional_nodepools" {
  type = map(object({
    node_count                     = number
    name                           = string
    mode                           = string
    vm_size                        = string
    taints                         = list(string)
    max_pods                       = number #250
    os_disk_size_gb                = number #128
    cluster_auto_scaling           = bool
    cluster_auto_scaling_min_count = number
    cluster_auto_scaling_max_count = number
    labels                         = map(string)
    availability_zones             = list(string)
  }))
  default = {
    "computepool01" = {
      node_count         = 1
      name               = "compute"
      mode               = "User"
      vm_size            = "Standard_B2ms"
      #"Standard_E2_v4" #Standard_B4ms "Standard_D2s_v3" "Standard_B2ms"
      availability_zones = ["1", "2", "3"]
      taints             = ["sku=compute:NoSchedule"]
      labels             = {
        load : "computeOptimized"
      }
      cluster_auto_scaling           = false
      cluster_auto_scaling_min_count = null
      cluster_auto_scaling_max_count = null
      max_pods                       = 250
      min_pods                       = null
      os_disk_size_gb                = 50
    },
    "memmory01" = {
      node_count         = 1
      name               = "memory"
      mode               = "User"
      vm_size            = "Standard_B2ms"
      availability_zones = ["1", "2", "3"]
      taints             = [""]
      labels             = {
        load : "memoryOptimized"
      }
      cluster_auto_scaling           = false
      cluster_auto_scaling_min_count = null
      cluster_auto_scaling_max_count = null
      max_pods                       = 250
      min_pods                       = null
      os_disk_size_gb                = 50
    },
  }
}

