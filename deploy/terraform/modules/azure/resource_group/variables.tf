//project-env-location
variable "prefix" {
  description = "Optional. A prefix to use for all the resource names"
  type = string
  default = null
}

variable "rg_name" {
  description = "Optional. Only required when prefix is not set."
  type = string
  default = null
}

variable "rg_location" {
  type        = string
  description = "Required. Accepted values can be retrieved with az account list-locations -o table"

}

variable "rg_tags" {
  type        = map(string)
  description = "Optional. A map/object of key value pairs to assign to the resource group."
}
