variable prefix {
  default = "mesh01-dev"
}


variable "api_server_authorized_ip_ranges" {
  default = []
}

variable "location" {
  default = "East US" #"westeurope"
}

variable "vnet_address_space" {
  default = ["10.23.0.0/16"]
}

variable "subnets" {
  default = {
    kube-subnet = {
      address_prefixes  = ["10.23.32.0/19"]
      service_endpoints = ["Microsoft.AzureCosmosDB", "Microsoft.Sql"]
    },
    generic-subnet = {
      address_prefixes  = ["10.23.0.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
  }
}

variable "tenant_id" {
  default = "63060cb1-0960-4615-8769-b110040fa763"
}

variable "admin_group_object_ids" {
  default = ["e1ad18a1-95ec-4cc4-8eb4-61a6aeecff1f"]
}

variable "additional_nodepools" {
  default = {
    "computepool01" = {
      node_count         = 1
      name               = "compute"
      mode               = "User"
      vm_size            = "Standard_B2ms"
      #"Standard_E2_v4" #Standard_B4ms "Standard_D2s_v3" "Standard_B2ms"
      availability_zones = ["1", "2", "3"]
      taints             = []
      labels             = {
        load : "computeOptimized"
      }
      cluster_auto_scaling           = false
      cluster_auto_scaling_min_count = null
      cluster_auto_scaling_max_count = null
      max_pods                       = 30
      min_pods                       = null
      os_disk_size_gb                = 50
    }
  }
}