locals {
  base_name = lower(replace(var.name_prefix, "_", "-"))
  tags = merge(var.tags, {
    workload = "multiagent-dfir"
    managed  = "terraform"
  })
  evidence_containers = toset([
    "evidence",
    "samples-quarantine",
    "memory-captures",
    "disk-images",
    "pcaps",
    "case-artifacts",
    "manifests",
  ])
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

resource "azurerm_servicebus_namespace" "main" {
  name                = "${local.base_name}-sb-${random_string.suffix.result}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "Standard"
  tags                = local.tags
}

resource "azurerm_servicebus_queue" "jobs" {
  name         = "dfir-jobs"
  namespace_id = azurerm_servicebus_namespace.main.id
}

resource "azurerm_storage_account" "main" {
  name                            = substr(replace("${local.base_name}${random_string.suffix.result}", "-", ""), 0, 24)
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  shared_access_key_enabled       = false
  public_network_access_enabled   = true
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true

    delete_retention_policy {
      days = 30
    }

    container_delete_retention_policy {
      days = 7
    }
  }

  tags = local.tags
}

resource "azurerm_storage_container" "evidence" {
  for_each              = local.evidence_containers
  name                  = each.value
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_key_vault" "main" {
  name                          = "${local.base_name}-kv-${random_string.suffix.result}"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  public_network_access_enabled = true
  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
  tags = local.tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_container_app_environment" "main" {
  name                       = "${local.base_name}-cae"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = local.tags
}

resource "azurerm_container_app" "orchestrator" {
  name                         = "${local.base_name}-orchestrator"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"
  tags                         = local.tags

  template {
    container {
      name   = "api"
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
