variable "resource_group_name" {
  description = "Required"
}

variable "servicebus_queue_name" {
  default = "Required"
}

variable "servicebus_namespace_name" {
  description = "Optional. Only required when prefix is not set"
}

variable "prefix" {
  description = "Optional. Only required when servicebus_namespace_name is not set"
}

variable "location" {
  description = "Required"
}

variable "sku" {
  description = "Required. Which tier to use. Options are basic, standard or premium. Changing this forces a new resource to be created."
  default = "Basic"
}

variable "tags" {}

variable "servicebus_namespace_identity_type" {
  description = "Optional. Options are SystemAssigned, UserAssigned"
  default = "SystemAssigned"
}

variable "servicebus_namespace_identity_ids" {
  type = list(string)
  default = null
  description = "Optional. Only required when identity is UserAssigned."

}