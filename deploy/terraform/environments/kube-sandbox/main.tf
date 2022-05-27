data "azurerm_kubernetes_service_versions" "current" {
  location = "East US"
}

data "azurerm_subscription" "primary" {
}

//using locals because interpolation would work
locals {
  common_tags = {
    environment = "sandbox"
  }
}

module "kube-group" {
  source = "../../modules/azure/resource_group"
  rg_name = "${var.prefix}-cluster-rg"
  rg_location = var.location
  rg_tags     = local.common_tags
}

module "vault" {
  source = "../../modules/azure/keyvault"
  location = var.location
  tags = local.common_tags
  prefix = var.prefix
  resource_group_name = module.kube-group.name
}

module "loganalytics" {
  source = "../../modules/azure/loganalytics"
  resource_group_name = module.kube-group.name
  tags = local.common_tags
  prefix = var.prefix
  location = var.location
}

module "vnet" {
  source = "../../modules/azure/vnet"
  tags                = local.common_tags
  vnet_address_space  = var.vnet_address_space
  vnet_location       = module.kube-group.rg_location
  vnet_resource_group = module.kube-group.name
  subnets             = var.subnets
  prefix              = var.prefix
}


module "mssql_server" {
  source = "../../modules/azure/mssql_server"
  location            = var.location
  vnet_rule_subnet_id = module.vnet.subnet_ids["kube-subnet"]
  databases = var.databases
  sql_firewall_rules = var.sql_firewall_rules
  tags = local.common_tags
  prefix = var.prefix
  resource_group_name = module.kube-group.name
  sa_administrator_login = var.sa_administrator_login
  sql_aad_admin_object_id = module.sql_server_user_assigned_identity.principal_id
  sql_aad_admin_login_username = module.sql_server_user_assigned_identity.identity_name
}

module "service_bus" {
  source = "../../modules/azure/servicebus"
  resource_group_name = module.kube-group.name
  tags                = local.common_tags
  location = var.location
  prefix = var.prefix
  servicebus_namespace_name = null
  servicebus_namespace_identity_type = "SystemAssigned"
  }

/*
module "cosmosdb" {
  source = "../../modules/azure/cosmosdb"
  location = var.location
  resource_group_name = module.kube-group.name
  tags = local.common_tags
  prefix = var.prefix
}
*/

module "kube" {
  source                          = "../../modules/azure/aks"
  depends_on                      = [
    module.vnet.subnet_ids
  ]
  prefix                          = var.prefix
  kube_resource_group_name        = module.kube-group.name
  dns_prefix                      = var.prefix
  location                        = var.location
  private_cluster_enabled         = false
  tags = local.common_tags
  loganalytics_workspace_id = module.loganalytics.log_analytics_workspace_id
  default_node_pool_name = "systempool"
  vnet_subnet_id = module.vnet.subnet_ids["kube-subnet"]
  api_server_authorized_ip_ranges  = var.api_server_authorized_ip_ranges
  default_node_pool_vnet_subnet_id = module.vnet.subnet_ids["kube-subnet"]
  node_resource_group              = "${var.prefix}-nodes-rg"
  admin_group_object_ids = var.admin_group_object_ids
  tenant_id = var.tenant_id
  local_account_disabled = false
  http_application_routing_enabled = false
  azurerm_container_registry_id = "/subscriptions/e267d216-a7aa-42e4-905a-f18316a144c4/resourceGroups/demo01-rg/providers/Microsoft.ContainerRegistry/registries/demo01cr"
  azurerm_container_registry_enabled = true
}

module "kube_nodepools" {
  source = "../../modules/azure/aks_nodepools"
  additional_nodepools = var.additional_nodepools
  kubernetes_cluster_id = module.kube.kube_cluster_id
  vnet_subnet_id        = module.vnet.subnet_ids["kube-subnet"]
  orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
}

module "aad_pod_identity" {
  source = "../../modules/azure/user_assigned_identity"
  location = module.kube.kube_cluster_location
  identity_name = "pod-identity"
  identity_resourcegroup_name = module.kube.kube_cluster_node_group
}

module "keda_user_assigned_pod_identity" {
  source = "../../modules/azure/user_assigned_identity"
  location = module.kube.kube_cluster_location
  identity_name = "keda-identity"
  identity_resourcegroup_name = module.kube.kube_cluster_node_group
}

module "cosmosdb_user_assigned_identity" {
  source = "../../modules/azure/user_assigned_identity"
  location = module.kube.kube_cluster_location
  identity_name = "cosmosdb-identity"
  identity_resourcegroup_name = module.kube.kube_cluster_node_group
}

module "service_bus_user_assigned_identity" {
  source = "../../modules/azure/user_assigned_identity"
  location = module.kube.kube_cluster_location
  identity_name = "service-bus-identity"
  identity_resourcegroup_name = module.kube.kube_cluster_node_group
}

module "sql_server_user_assigned_identity" {
  source = "../../modules/azure/user_assigned_identity"
  location = module.kube.kube_cluster_location
  identity_name = "sql-server-identity"
  identity_resourcegroup_name = module.kube.kube_cluster_node_group
}

module "key_vault_user_assigned_identity" {
  source = "../../modules/azure/user_assigned_identity"
  location = module.kube.kube_cluster_location
  identity_name = "key-vault-identity"
  identity_resourcegroup_name = module.kube.kube_cluster_node_group
}

resource "azurerm_role_assignment" "service_bus_identity_assignment" {
  scope                = module.service_bus.servicebus_namespace_id
  role_definition_name = "Azure Service Bus Data Owner"
  principal_id         = module.service_bus_user_assigned_identity.principal_id
}

resource "azurerm_key_vault_secret" "sql_sa_admin_password" {
  name         = module.mssql_server.sql_server_sa_login
  value        = module.mssql_server.sql_server_sa_password
  key_vault_id = module.vault.vault_id
}


resource "null_resource" "enable-pod-identity" {
  provisioner "local-exec" {
    command = <<EOT
    az extension update --name aks-preview
    az aks get-credentials -n ${module.kube.kube_cluster_name} -g ${module.kube.kube_cluster_resource_group} --admin
    az aks update -n ${module.kube.kube_cluster_name} -g ${module.kube.kube_cluster_resource_group} --enable-pod-identity
    EOT
  }
  depends_on = [
    module.kube_nodepools.nodepools
  ]
}
