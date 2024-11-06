variable "stage" {
  type        = string
  description = "Environment Variable, possible values = dev,qa,prod"
}

variable "location" {
  type        = string
  description = "Location where to create resources"
}

variable "client_name" {
  type        = string
  description = "Name of the client"
}

variable "project_name" {
  type        = string
  description = "Name of the Project"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID" 
}

variable "tenantId" {
  type        = string
  description = "Azure Tenant ID" 
}

variable "azure_ad_client_id" {
  type        = string
  description = "Azure Tenant ID" 
}

variable "azure_ad_client_secret" {
  type        = string
  description = "Azure Tenant ID" 
}

variable "nextauth_secret" {
  type        = string
  description = "Azure Tenant ID" 
}

variable "container_registry_admin_password" {
  type        = string
  description = "Azure Tenant ID" 
}

variable "container_registry_login_server" {
  type        = string
  description = "Azure Tenant ID" 
}

variable "container_registry_admin_username" {
  type        = string
  description = "Azure Tenant ID" 
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group" 
}

variable "storage_account_connection_string" {
  type        = string
  description = "storage account connection string" 
}