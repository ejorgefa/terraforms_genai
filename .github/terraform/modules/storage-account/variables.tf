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
  description = "The client name of this application"
  default     = "ine"
}

variable "application_name" {
  type        = string
  description = "The name of your application"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}

variable "account_tier" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "Standard"
}

variable "account_replication_type" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "LRS"
}

variable "name" {
  type = string
  description = "Name of the Storage Account"
}