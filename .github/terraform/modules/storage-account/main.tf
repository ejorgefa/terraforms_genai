terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.26"
    }
  }
}

# resource "azurecaf_name" "storage_account" {
#   name          = var.application_name
#   resource_type = "azurerm_storage_account"
#   suffixes      = [var.environment]
# }

resource "azurerm_storage_account" "tfstate" {
  name                     = "${var.name}"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  allow_nested_items_to_be_public = false

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

