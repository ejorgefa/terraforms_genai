terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.26"
    }
  }
}

resource "azurecaf_name" "container_registry" {
  name          = var.application_name
  resource_type = "azurerm_container_registry"
  suffixes      = [var.environment]
}

resource "azurerm_container_registry" "container-registry" {
  name                = azurecaf_name.container_registry.result
  resource_group_name = var.resource_group
  location            = var.location
  admin_enabled       = true
  sku                 = "Basic"

  tags = {
    "environment"      = var.environment
    "application-name" = var.application_name
  }
}

