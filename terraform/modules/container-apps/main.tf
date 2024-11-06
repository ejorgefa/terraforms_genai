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

resource "azurecaf_name" "containerapp" {
  name          = "${var.project_name}-${var.application_group}-${var.application_name}"
  resource_type = "azurerm_container_app"
  suffixes      = [var.environment]
}

resource "azurerm_container_app" "containerapp" {
  name                         = azurecaf_name.containerapp.result
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group
  revision_mode                = "Single"

  tags = {
    "client-name"       = var.client_name
    "application-name"  = var.application_name
    "environment"       = var.environment
  }

  lifecycle {
    ignore_changes = [
      template.0.container["image"]
    ]
  }

  secret {
    name  = "registry-credentials"
    value = var.container_registry.admin_password
  }

  registry {
    server               = var.container_registry.login_server
    username             = var.container_registry.admin_username
    password_secret_name = "registry-credentials"
  }

  dapr {
    app_id       = var.dapr_name
    app_port     = var.http_port
  }

  ingress {
    external_enabled = true
    target_port      = var.http_port
    traffic_weight {
      percentage = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = azurecaf_name.containerapp.result
      image  = var.docker_image
      cpu    = var.cpu
      memory = var.memory

      dynamic env {
        for_each = var.environment_variables
        iterator = item
        content {
          name  = item.value.name
          value = item.value.value
        }
      }

    }
    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
  }
}


# workaround while above does not support cors
#https://github.com/hashicorp/terraform-provider-azurerm/issues/21073#issuecomment-1905740054
resource "azapi_update_resource" "set_cors" {
  type        = "Microsoft.App/containerApps@2023-05-01"
  resource_id = azurerm_container_app.containerapp.id

  body = jsonencode({
    properties = {
      configuration = {
        # Duplicate all secrets here
        secrets = [
          {
            name  = "registry-credentials"
            value = var.container_registry.admin_password
          }
        ]
        ingress = {
          corsPolicy = {
            allowedOrigins = var.allowedOrigins
            allowedHeaders = ["*"]
          }
        }
      }
    }
  })
} 

