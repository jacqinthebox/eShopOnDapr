variable "location" {
  description = "(Required). The location of the cluster. Optional value are `az account list-locations -o table`"
  type = string
  default = "West Europe"
}

variable "tags" {
  type        = map(any)
  description = "Any tags that should be defined on resources"
}

variable "prefix" {
  type        = string
  description = "A common denominator for a group of resources"
  default = null
}

variable "log_analytics_workspace_name" {
  description = "(Required). The name of the analytics workspace. Required when prefix is not set."
  type        = string
  default = null
}

variable "resource_group_name" {
  description = "(Required).The resource group name of the cluster"
  type        = string
}


variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  type        = number
  default     = 30
}
