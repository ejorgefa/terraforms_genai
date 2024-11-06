variable "resource_group" {
  type        = string
  description = "The resource group"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}

variable "client_name" {
  type        = string
  description = "The name of the client"
}

variable "project_name" {
  type        = string
  description = "The name of your project"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "openai" {
  type = object({
    location            = optional(string)
    sku                 = optional(string)
    model-name          = optional(string)
    model-version       = optional(string)
    model-scale         = optional(string)
    embeddings-name     = optional(string)
    embeddings-version  = optional(string)
    embeddings-scale    = optional(string)
  })
  default = {
    location            = "swedencentral"
    sku                 = "S0"
    model-name          = "gpt-4o-mini"
    model-version       = "2024-07-18"
    model-scale         = "Standard"
    embeddings-name     = "text-embedding-3-large"
    embeddings-version  = "1"
    embeddings-scale    = "Standard"
  }
  validation {
    condition     = contains([
      "text-embedding-3-large",
      "text-embedding-3-small",
      "text-embedding-ada-002"], var.openai.embeddings-name)
    error_message = "The model version must be one of the following values:text-embedding-3-large, text-embedding-3-small or text-embedding-ada-002."
  }

  validation {
    condition     = contains([
      "gpt-4",
      "gpt-4o",
      "gpt-4o-mini",
      "gpt-4-32k",
      "gpt-35-turbo",
      "gpt-35-turbo-16k",
      "gpt-35-turbo-instruct",
      "gpt-35-turbo-instruct"], var.openai.model-name)
    error_message = "The model version must be one of the following values: gpt-4, gpt-4-32k, gpt-35-turbo, gpt-35-turbo-16k, gpt-35-turbo-instruct, gpt-35-turbo-instruct."
  }
  validation {
    condition     = contains(["S0"], var.openai.sku)
    error_message = "The sku must be one of the following values: S0."
  }
  validation {
    condition     = contains([
  "eastus",
  "eastus2",
  "southcentralus",
  "westus2",
  "westus3",
  "australiaeast",
  "southeastasia",
  "northeurope",
  "swedencentral",
  "uksouth",
  "westeurope",
  "centralus",
  "southafricanorth",
  "centralindia",
  "eastasia",
  "japaneast",
  "koreacentral",
  "canadacentral",
  "francecentral",
  "germanywestcentral",
  "italynorth",
  "norwayeast",
  "polandcentral",
  "switzerlandnorth",
  "uaenorth",
  "brazilsouth",
  "centraluseuap",
  "israelcentral",
  "qatarcentral",
  "centralusstage",
  "eastusstage",
  "eastus2stage",
  "northcentralusstage",
  "southcentralusstage",
  "westusstage",
  "westus2stage",
  "asia",
  "asiapacific",
  "australia",
  "brazil",
  "canada",
  "europe",
  "france",
  "germany",
  "global",
  "india",
  "japan",
  "korea",
  "norway",
  "singapore",
  "southafrica",
  "sweden",
  "switzerland",
  "uae",
  "uk",
  "unitedstates",
  "unitedstateseuap",
  "eastasiastage",
  "southeastasiastage",
  "brazilus",
  "eastusstg",
  "northcentralus",
  "westus",
  "japanwest",
  "jioindiawest",
  "eastus2euap",
  "westcentralus",
  "southafricawest",
  "australiacentral",
  "australiacentral2",
  "australiasoutheast",
  "jioindiacentral",
  "koreasouth",
  "southindia",
  "westindia",
  "canadaeast",
  "francesouth",
  "germanynorth",
  "norwaywest",
  "switzerlandwest",
  "ukwest",
  "uaecentral",
  "brazilsoutheast"
], var.openai.location)
    error_message = "The sku must be one of the following values: s0."
  }
}