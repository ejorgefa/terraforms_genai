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

variable "log_analytics_workspace_id" {
  type        = string
  description = "The id of log analytics workspace"
}

variable "messaging_dapr_scopes" {
  type        = list(string)
  description = "What apps have access to Dapr PubSub"
}

variable "messaging_dapr_redis_host" {
  type        = string
  description = "Dapr PubSub Redis instance host"
}

variable "messaging_dapr_redis_secret" {
  type        = string
  description = "Dapr PubSub Redis instance password"
}