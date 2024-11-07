terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.26"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.108.0"
    }
  }
}

locals {
  service_name = "${var.client_name}-${var.project_name}-${var.environment}"
}

resource "azurerm_search_service" "search" {
  name                = "ais-${local.service_name}"
  resource_group_name = var.resource_group
  location            = var.location
  sku                 = var.aisearch.sku
  replica_count       = var.aisearch.replica_count
  partition_count     = var.aisearch.partition_count

  tags = {
    "environment"      = var.environment
    "application-name" = var.project_name
  }
}

# resource "azurerm_search_index" "search_index" {
#   name                = "personahub-${var.project_name}-${var.environment}"
#   resource_group_name = var.resource_group
#   search_service_name = resource.azurerm_search_service.search.name
# }


