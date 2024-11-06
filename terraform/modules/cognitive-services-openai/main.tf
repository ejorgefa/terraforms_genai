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

resource "azurerm_cognitive_account" "openai" {
  name                = "oai-${local.service_name}"
  resource_group_name = var.resource_group
  location            = var.openai.location
  sku_name            = var.openai.sku
  kind                = "OpenAI"

  tags = {
    "environment"      = var.environment
    "application-name" = var.project_name
  }
}


