locals {
  base_name = lower(replace(var.name_prefix, "_", "-"))
  tags = merge(var.tags, {
    workload = "cloud-mcp-gateway"
    managed  = "terraform"
  })
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_resource_group" "main" {
  name     = "${local.base_name}-rg"
  location = var.location
  tags     = local.tags
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "${local.base_name}-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

resource "azurerm_container_app_environment" "main" {
  name                       = "${local.base_name}-cae"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = local.tags
}

resource "azurerm_container_app" "mcp_gateway" {
  name                         = "${local.base_name}-gateway"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = local.tags

  template {
    container {
      name   = "mcp-gateway"
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_api_management" "main" {
  name                = "${local.base_name}-apim-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = "multiagent-platform"
  publisher_email     = "platform@example.com"
  sku_name            = "Consumption_0"
  tags                = local.tags
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "mcp_gateway_fqdn" {
  value = try(azurerm_container_app.mcp_gateway.ingress[0].fqdn, null)
}

output "apim_name" {
  value = azurerm_api_management.main.name
}
