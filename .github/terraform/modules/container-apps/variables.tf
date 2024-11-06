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
  description = "The name of your project"
}

variable "application_name" {
  type        = string
  description = "The name of your application"
}

variable "application_group" {
  type        = string
  description = "The name of application group, i.e. apps, services, etc."
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

variable "cpu" {
  type        = number
  default     = 0.5
  description = "The cpu used by the container app"
}
variable "memory" {
  type        = string
  default     = "1Gi"
  description = "The memory used by the container app"
}
variable "docker_image" {
  type        = string
  default     = "nginx:latest"
  description = "The default docker image"
}
variable "container_app_environment_id" {
  type        = string
  description = "The id of the container app environment"
}
variable "dapr_name" {
  type        = string
  description = "The dapr service name"
}

variable "http_port" {
  type        = number
  default     = 80
  description = "The port used by the container app"
}

variable "min_replicas" {
  type        = number
  default     = 1
  description = "The minimum number of replicas for the container app"
}

variable "max_replicas" {
  type        = number
  default     = 3
  description = "The maximum number of replicas for the container app"
}

variable "allowedOrigins" {
  type    = list(string)
  default = []
}


variable "container_registry" {
  type        = object({
    admin_password = string
    login_server = string
    admin_username = string
  })
  sensitive = true
}
/*
environment_variables         = {
    AZURE_OPENAI_CHATGPT_DEPLOYMENT   = chat
    AZURE_OPENAI_CHATGPT_MODEL        = gpt-35-turbo
    AZURE_OPENAI_EMBEDDING_DEPLOYMENT = embedding
    AZURE_OPENAI_EMBEDDING_MODEL      = text-embedding-ada-002
    AZURE_OPENAI_SERVICE              = cog-mqqvkjiywet7s
    AZURE_SEARCH_INDEX                = gptkbindex
    AZURE_SEARCH_SERVICE              = gptkb-mqqvkjiywet7s
    AZURE_STORAGE_ACCOUNT             = stmqqvkjiywet7s
    AZURE_STORAGE_CONTAINER           = content
  }
*/
variable "environment_variables" {
  description = "list of values to assign to the environment variables in the container app"
  type = list(object({
    name           = string
    value = string
  }))
}

# variable "environment_variables" {
#   type        = map
# }