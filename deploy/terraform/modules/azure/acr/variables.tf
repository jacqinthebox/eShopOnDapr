variable "location" {
  type = string
  description = "(Required). Location."
}

variable "prefix" {
  type = string
  description = "The prefix. Required when resource_group_name is not set"
  default = null
}

variable "resource_group_name" {
  description = "Resource group name. Required when prefix is not set"
  type = string
  default = null
}

variable "acr_name" {
  description = "ACR name. Required when prefix is not set"
  type = string
  default = null
}

variable "tags" {
  type = map(string)
  description = "(Optional). A map of key value pairs to tag resources"
}

variable "acr_sku" {
  description = "(Required). The SKU name of the container registry. Possible values are Basic, Standard and Premium."
  default = "Basic"
}

variable "admin_enabled" {
  description = "(Optional). Specifies whether the admin user is enabled. Defaults to false."
  default = false
}