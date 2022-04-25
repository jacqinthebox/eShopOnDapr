variable "prefix" {
  default = null
}

variable "resource_group_name" {}

variable "sku" {
  description = "Required. Which tier to use. Options are basic, standard or premium. Changing this forces a new resource to be created."
  default = "basic"
}

variable "tags" {
  type = map(any)
  default = null
}

variable "location" {}

variable "cosmosdb_kind" {
  type = string
  default = "GlobalDocumentDB"
  description = "(Optional) Specifies the Kind of CosmosDB to create - possible values are GlobalDocumentDB and MongoDB. Defaults to GlobalDocumentDB. Changing this forces a new resource to be created."
}

variable "cosmosdb_account_name" {
  default = null
}

variable "cosmosdb_consistency_policy" {
  default = "Eventual"
}

variable "cosmosdb_sql_container_name" {
  default = null
}

variable "partition_key_path" {
  description = "Required. Partition Key Path, starts with '/'"
  default = "/partitionKey"
}

variable "cosmosdb_db_name" {
  default = null
}
