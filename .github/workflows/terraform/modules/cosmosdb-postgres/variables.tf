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

variable "application_name" {
  type        = string
  description = "The name of your application"
}

variable "database_admin_password" {
  type        = string
  description = "The password of database administrator"
}

variable "environment" {
  type        = string
  description = "The environment (dev, test, prod...)"
  default     = "dev"
}
