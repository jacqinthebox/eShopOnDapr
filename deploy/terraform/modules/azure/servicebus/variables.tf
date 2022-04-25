variable "sb_namespace_name" {
  default = null
}
variable "prefix" {
  default = null
}
variable "location" {}

variable "resource_group_name" {}
variable "sku" {
  description = "Required. Which tier to use. Options are basic, standard or premium. Changing this forces a new resource to be created."
  default = "Basic"
}
variable "tags" {}
