terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.108.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.26"
    }
  }
}

resource "azurecaf_name" "app_name" {
  name          = "${var.client_name}-${var.project_name}"
  resource_type = "azurerm_redis_cache"
  suffixes      = [var.environment]
}

# NOTE: the Name used for Redis needs to be globally unique
resource "azurerm_redis_cache" "redis" {
  name                = azurecaf_name.app_name.result
  location            = var.location
  resource_group_name = var.resource_group
  capacity            = 0
  family              = "C"
  sku_name            = "Basic"
  enable_non_ssl_port = false

  tags = {
    "environment"      = var.environment
    "application-name" = var.project_name
  }
}