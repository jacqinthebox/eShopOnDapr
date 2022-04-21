variable pip_name {}
variable nsg_name {}
variable nic_name {}
variable vm_name {}
variable computer_name {}

variable resource_group {
  type = string
}

variable location {
  type = string
}

variable vnet_id {
  description = "ID of the VNET where the vm will be installed"
  type        = string
}

variable subnet_id {
  description = "ID of subnet where the vm will be installed"
  type        = string
}

variable nsg_source_address_prefixes {
  description = "A list of IP CIDR ranges to allow as clients."
  default     = ["*"]
  type        = list(string)
}

variable nsg_source_address_prefix {
  description = "An IP address."
  default     = "*"
  type        = string
}

#variable nsg_source_address_prefix {
#  description = "A single IP address to allow as client."
#  default     = null
#}

variable "nsg_source_port_range" {
  default = "*"
}

variable vm_admin_user {
  default     = "labadmin"
}

variable vm_admin_password {
  default     = "labadminpassword"
  sensitive = true
}

variable "disable_password_authentication" {
  default = true
}

variable "vm_os_disk_name" {
  default = ""
}

variable prefix {}