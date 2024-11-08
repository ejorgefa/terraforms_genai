terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.108.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "1.2.26"
    }
    azapi = {
      source = "Azure/azapi"
      version = "1.12.1"
    }

    # restapi = {
    #   source = "Mastercard/restapi"
    #   version = "1.19.1"
    # }
  }
  backend "azurerm" {}
  # backend "azurerm" {
  #     resource_group_name  = ""
  #     storage_account_name = ""
  #     container_name       = "tfstate"
  #     key                  = "terraform.tfstate"
  # }
}

# provider "restapi" {
#   uri                  = module.main-aisearch.aisearch_url
#   write_returns_object = true
#   debug                = true

#   headers = {
#     "api-key"      = module.main-aisearch.aisearch_primary_key,
#     "Content-Type" = "application/json"
#   }

#   create_method  = "POST"
#   update_method  = "PUT"
#   destroy_method = "DELETE"
# }


provider "azurerm" {
  features {}
}