resource "azurerm_log_analytics_workspace" "space" {
  name                = var.log_analytics_workspace_name == null ? "${var.prefix}-loganalytics-workspace" : var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_workspace_sku
}

/*
resource "azurerm_log_analytics_solution" "solution" {
  solution_name         = "containerinsights"
  location              = azurerm_log_analytics_workspace.space.location
  resource_group_name   = azurerm_log_analytics_workspace.space.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.space.id
  workspace_name        = azurerm_log_analytics_workspace.space.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
} */