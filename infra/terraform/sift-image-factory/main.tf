locals {
  base_name = lower(replace(var.name_prefix, "_", "-"))
  tags = merge(var.tags, {
    workload = "sift-image-factory"
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

resource "azurerm_storage_account" "scripts" {
  name                     = substr(replace("${local.base_name}scr${random_string.suffix.result}", "-", ""), 0, 24)
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  tags                     = local.tags
}

resource "azurerm_storage_container" "scripts" {
  name                  = "scripts"
  storage_account_id    = azurerm_storage_account.scripts.id
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "image_builder" {
  name                = "${local.base_name}-aib-mi"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

resource "azurerm_shared_image_gallery" "main" {
  name                = "${replace(local.base_name, "-", "")}${random_string.suffix.result}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  description         = "SIFT hardened image gallery"
  tags                = local.tags
}

resource "azurerm_shared_image" "sift" {
  name                = var.image_definition_name
  gallery_name        = azurerm_shared_image_gallery.main.name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  hyper_v_generation  = "V2"

  identifier {
    publisher = "sift"
    offer     = "dfir"
    sku       = "ubuntu2204"
  }

  tags = local.tags
}

resource "azurerm_role_assignment" "aib_storage_blob_data_contributor" {
  scope                = azurerm_storage_account.scripts.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.image_builder.principal_id
}

resource "azurerm_role_assignment" "aib_image_contributor" {
  scope                = azurerm_shared_image_gallery.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.image_builder.principal_id
}

resource "azurerm_role_assignment" "aib_rg_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.image_builder.principal_id
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "image_gallery_name" {
  value = azurerm_shared_image_gallery.main.name
}

output "image_definition_name" {
  value = azurerm_shared_image.sift.name
}

output "managed_identity_client_id" {
  value = azurerm_user_assigned_identity.image_builder.client_id
}

output "next_step" {
  value = "Publish scripts/sift-install.sh and scripts/sift-hardening.sh to storage, then create Azure Image Builder template for image version publication."
}
