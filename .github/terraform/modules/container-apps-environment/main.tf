terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.26"
    }
    azapi = {
      source = "Azure/azapi"
      version = "1.12.1"
    }
    template = {
      source = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

resource "azurecaf_name" "application-environment" {
  name          = "${var.client_name}-${var.project_name}"
  resource_type = "azurerm_container_app_environment"
  suffixes      = [var.environment]
}

resource "azurerm_container_app_environment" "application" {
  name                       = azurecaf_name.application-environment.result
  resource_group_name        = var.resource_group
  location                   = var.location
  log_analytics_workspace_id = var.log_analytics_workspace_id

  tags = {
    "environment"      = var.environment
    "application-name" = var.project_name
  }
}

resource "azurerm_container_app_environment_dapr_component" "pubsub" {
  name                         = "pubsub"
  container_app_environment_id = azurerm_container_app_environment.application.id
  component_type               = "pubsub.redis"
  version                      = "v1"
  scopes                       = var.messaging_dapr_scopes

  secret {
    name  = "redispassword"
    value = var.messaging_dapr_redis_secret
  }

  metadata {
    name  = "redisHost"
    value = var.messaging_dapr_redis_host
  }

  metadata {
    name  = "redisDB"
    value = "0"
  }

  metadata {
    name  = "redisPassword"
    secret_name = "redispassword"
  }

  metadata {
    name  = "enableTLS"
    value = "true"
  }
}

