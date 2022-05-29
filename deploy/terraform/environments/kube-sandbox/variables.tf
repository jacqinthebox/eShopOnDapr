variable prefix {
  default = "kube-sbx-b"
}

variable "tenant_id" {} #will be set from environment variable

variable "location" {
  default = "East US" #"westeurope"
}

variable "acr_id" {
  default = "/subscriptions/e267d216-a7aa-42e4-905a-f18316a144c4/resourceGroups/demo01-rg/providers/Microsoft.ContainerRegistry/registries/demo01cr"
}

variable "databases" {
  default = [
    {name: "Microsoft.eShopOnDapr.Services.CatalogDb", license_type: "BasePrice",sku_name: "Basic", zone_redundant: false },
    {name: "Microsoft.eShopOnDapr.Services.IdentityDb", license_type: "BasePrice",sku_name: "Basic", zone_redundant: false },
    {name: "Microsoft.eShopOnDapr.Services.OrderingDb", license_type: "BasePrice",sku_name: "Basic", zone_redundant: false },

  ]
}

variable "sql_firewall_rules" {
  default = [{ name : "office_hq", start_ip_address = "1.2.3.4", end_ip_address= "1.2.3.4" },]
}

# this is set via environment variable in Github Actions
variable "sa_administrator_login" {
  default = null
}

variable "aad_admins_object_id" {
  default = "e1ad18a1-95ec-4cc4-8eb4-61a6aeecff1f"
}
variable "sql_aad_admin_login_username" {
  default = "aks-admins"
}

variable "vnet_address_space" {
  default = ["10.23.0.0/16"]
}

variable "subnets" {
  default = {
    kube-subnet = {
      address_prefixes  = ["10.23.32.0/19"]
      service_endpoints = ["Microsoft.AzureCosmosDB", "Microsoft.Sql", "Microsoft.KeyVault", "Microsoft.ServiceBus","Microsoft.ContainerRegistry"]
    },
    generic-subnet = {
      address_prefixes  = ["10.23.0.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
    }
  }
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
      taints             = []#["sku=compute:NoSchedule"]
      labels             = {
        load : "computeOptimized"
      }
      cluster_auto_scaling           = true
      cluster_auto_scaling_min_count = 1
      cluster_auto_scaling_max_count = 3
      max_pods                       = 30
      min_pods                       = null
      os_disk_size_gb                = 50
    }
  }
}
