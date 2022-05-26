variable "prefix" {
  default = null
}
variable "sql_server_name" {
  default = null
}
variable "sql_admin_name" {
  default = null
}
variable "location" {

}
variable "resource_group_name" {
  default = null
}

variable "sql_aad_admin_login_username" {
  description = "Required. The aad admin user name, or the display name of the managed identity"
}

variable "sql_aad_admin_object_id" {
  default = "Required. The object id (principal id) of the aad admin user or managed identity"
}
variable "sa_administrator_login" {
  default = "Required. The sa admin login."
}

variable "tags" {}

variable "vnet_rule_subnet_id" {}

variable "sql_version" {
  default = "12.0"
  type = string
  description = "Sql Server version"
}

variable "sql_firewall_rules" {
  description = "Required. A list of sql firewall rules."
  type        = list(object({
    name             = string
    start_ip_address = string
    end_ip_address    = string
  }))
  default = [
    { name : "office_hq", start_ip_address = "1.2.3.4", end_ip_address = "1.2.3.4" },
  ]
}

variable "databases" {
  description = "Required. A list of databases"
  type    = list(object({
    name = string
    license_type = string
    sku_name = string
    zone_redundant = bool
  }))
  default = [
    {name: "db01", license_type: "BasePrice",sku_name: "Basic", zone_redundant: false },
  ]
}


variable "identity_type" {
  default = "SystemAssigned"
  type = string
  description = "Required. SystemAssigned or UserAssigned. MSI type"
}

variable "identity_ids" {
  default = null
  type = list
  description = "identities list. Required when type us set to UserAssigned"
}

/*license_type - (Optional) Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice.*/
/*sku_name - (Optional) Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. Changing this from the HyperScale service tier to another service tier will force a new resource to be created.*/

