variable "resource_group" {
  type        = string
  description = "The resource group"
}

variable "location" {
  type        = string
  description = "The Azure region where all resources in this example should be created"
}

variable "project_name" {
  type        = string
  description = "The name of your application"
}

variable "client_name" {
  type        = string
  description = "The name of the client"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "aisearch" {
  type = object({
    partition_count = optional(number)
    replica_count   = optional(number)
    sku             = optional(string)
  })
  default = {
    partition_count = 1
    replica_count   = 1
    sku             = "free"
  }
  validation {
    condition     = contains([1, 2, 3, 4, 6, 12], var.aisearch.partition_count)
    error_message = "The partition_count must be one of the following values: 1, 2, 3, 4, 6, 12."
  }
  validation {
    condition     = var.aisearch.replica_count >= 1 && var.aisearch.replica_count <= 12
    error_message = "The replica_count must be between 1 and 12."
  }
  validation {
    condition     = contains(["free", "basic", "standard", "standard2", "standard3", "storage_optimized_l1", "storage_optimized_l2"], var.aisearch.sku)
    error_message = "The sku must be one of the following values: free, basic, standard, standard2, standard3, storage_optimized_l1, storage_optimized_l2."
  }
}






