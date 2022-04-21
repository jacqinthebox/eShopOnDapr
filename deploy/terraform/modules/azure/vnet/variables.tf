//project-env-location
variable "prefix" {
  description = "Optional. A prefix to use for the all the names"
  type = string
  default = null
}

variable "vnet_name" {
  description = "Optional. Only required when prefix is not set."
  type = string
  default = null
}

variable "vnet_address_space" {
  description = "Required. A list of address spaces for the vnet"
  type = list(string)
}

variable "vnet_location" {
  description = "Required. Accepted values can be retrieved with az account list-locations -o table"
  type = string
}


variable "vnet_resource_group" {
  description = "Required. The name of the resource group to create the resource in"
  type = string
  default = null
}


variable "subnet_name" {
  description = "Optional. The name of the subnet. Only required when prefix is not set."
  default = null
  type = string
}

variable "subnets" {
  description = "Required. A map of string, object with the subnet definition"
  type    = map(object({
    address_prefixes     = list(string)
    service_endpoints    = list(string)
  }))
  /*default = {
    "subnet-1" = {
      address_prefixes     = ["172.16.1.0/24"]
      service_endpoints    = ["Microsoft.AzureCosmosDB","Microsoft.Sql"]
    },
    "subnet-2" = {
      address_prefixes     = ["172.16.2.0/24"]
      service_endpoints    = ["Microsoft.Storage","Microsoft.KeyVault"]
    }
  */
}


variable "tags" {
  description = "Optional. A map of string, string with tag info"
  type = map(string)
  //default = {
  //    owner = "name"
  //    department = "research"
  //  }
}
