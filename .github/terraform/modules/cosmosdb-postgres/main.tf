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

resource "azurerm_cosmosdb_postgresql_cluster" "cluster" {
  resource_group_name                   = var.resource_group
  location                              = var.location
  name                                  = "db-${var.client_name}-${var.application_name}-${var.environment}"
  administrator_login_password          = var.database_admin_password
  coordinator_server_edition            = "BurstableMemoryOptimized"
  coordinator_storage_quota_in_mb       = 32768
  coordinator_vcore_count               = 1
  # does not seems to be working :/
  # one must manualy go to the portal, and on the networking
  # enable "Allow public access from Azure services and resources within Azure to this cluster"
  # otherwise the microservices will not work
  coordinator_public_ip_access_enabled  = true
  node_count                            = 0

  tags = {
    "client-name"       = var.client_name
    "application-name"  = var.application_name
    "environment"       = var.environment
  }
}