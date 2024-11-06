module "container-app-environment" {
  source                      = "./modules/container-apps-environment"
  depends_on                  = [ module.log-analytics-workspace, module.redis-cache ]
  resource_group              = var.resource_group_name
  client_name                 = var.client_name
  project_name                = var.project_name
  environment                 = local.environment
  location                    = var.location
  log_analytics_workspace_id  = module.log-analytics-workspace.log_analytics_workspace_id
  messaging_dapr_scopes       = ["ms-indexer", "ms-datasources", "ms-chat", "ms-personas", "ms-storage", "app-studio", "app-hub"]
  messaging_dapr_redis_host   = "${module.redis-cache.redis_cache_host}:${module.redis-cache.redis_cache_port}"
  messaging_dapr_redis_secret = module.redis-cache.redis_cache_key
}

module "container-app-services-personas" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/services/personas:1.0.28"
  depends_on                    = [ module.main-database ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "services"
  application_name              = "personas"
  dapr_name                     = "ms-personas"
  max_replicas                  = 1
  http_port                     = 4000
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [{
      name  = "API_PORT",
      value = "4000"
    },{
      name  = "API_HOST",
      value = "0.0.0.0"
    },{
      name  = "LOG_LEVEL",
      value = "debug"
    },{
      name  = "NODE_ENV",
      value = "production"
    },{
      name  = "DATABASE_URL",
      value = "${module.main-database.connectionstring}"
    },{
      name  = "AZURE_TENANT_ID",
      value = "${var.tenantId}"
    }]
}

module "container-app-services-llm" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/services/large-language-models:1.0.15"
  depends_on                    = [ module.main-database ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "services"
  application_name              = "llm"
  dapr_name                     = "ms-llm"
  max_replicas                  = 1
  http_port                     = 4000
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [{
      name  = "API_PORT",
      value = "4000"
    },{
      name  = "API_HOST",
      value = "0.0.0.0"
    },{
      name  = "LOG_LEVEL",
      value = "debug"
    },{
      name  = "NODE_ENV",
      value = "production"
    },{
      name  = "DATABASE_URL",
      value = "${module.main-database.connectionstring}"
    },{
      name  = "AZURE_TENANT_ID",
      value = "${var.tenantId}"
    }]
}

module "container-app-services-global" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/services/global:1.0.13"
  depends_on                    = [ module.main-database ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "services"
  application_name              = "global"
  dapr_name                     = "ms-global"
  max_replicas                  = 1
  http_port                     = 4000
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [{
      name  = "API_PORT",
      value = "4000"
    },{
      name  = "API_HOST",
      value = "0.0.0.0"
    },{
      name  = "LOG_LEVEL",
      value = "debug"
    },{
      name  = "NODE_ENV",
      value = "production"
    },{
      name  = "DATABASE_URL",
      value = "${module.main-database.connectionstring}"
    },{
      name  = "AZURE_TENANT_ID",
      value = "${var.tenantId}"
    }]
}

module "container-app-services-storage" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/services/storage:1.0.9"
  depends_on                    = [ module.container-app-environment, module.main-database ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "services"
  application_name              = "storage"
  dapr_name                     = "ms-storage"
  max_replicas                  = 1
  http_port                     = 4000
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [{
      name  = "API_PORT",
      value = "4000"
    },{
      name  = "API_HOST",
      value = "0.0.0.0"
    },{
      name  = "LOG_LEVEL",
      value = "debug"
    },{
      name  = "NODE_ENV",
      value = "production"
    },{
      name  = "DATABASE_URL",
      value = "${module.main-database.connectionstring}"
    },{
      name  = "AZURE_TENANT_ID",
      value = "${var.tenantId}"
    },{
      name  = "AZURE_STORAGE_ACCOUNT_CONNECTIONSTRING",
      value = "${var.storage_account_connection_string}"
    },{
      name  = "FASTIFY_PLUGIN_TIMEOUT",
      value = "20000"
    }]
}

module "container-app-services-datasources" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/services/datasources:1.0.25"
  depends_on                    = [ module.container-app-environment, module.main-database, module.container-app-services-storage ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "services"
  application_name              = "datasources"
  dapr_name                     = "ms-datasources"
  max_replicas                  = 1
  http_port                     = 4000
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [{
      name  = "API_PORT",
      value = "4000"
    },{
      name  = "API_HOST",
      value = "0.0.0.0"
    },{
      name  = "LOG_LEVEL",
      value = "debug"
    },{
      name  = "NODE_ENV",
      value = "production"
    },{
      name  = "DATABASE_URL",
      value = "${module.main-database.connectionstring}"
    },{
      name  = "AZURE_TENANT_ID",
      value = "${var.tenantId}"
    },{
      name  = "SERVICES_STORAGE_URL",
      value = "${module.container-app-services-storage.application_caf_url}"
    }]
}

module "container-app-services-indexer" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/services/indexer:1.0.22"
  depends_on                    = [ module.main-database, module.container-app-services-storage ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "services"
  application_name              = "indexer"
  dapr_name                     = "ms-indexer"
  max_replicas                  = 1
  http_port                     = 4000
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [{
      name  = "API_PORT",
      value = "4000"
    },{
      name  = "API_HOST",
      value = "0.0.0.0"
    },{
      name  = "LOG_LEVEL",
      value = "debug"
    },{
      name  = "NODE_ENV",
      value = "production"
    },{
      name  = "DATABASE_URL",
      value = "${module.main-database.connectionstring}"
    },{
      name  = "AZURE_TENANT_ID",
      value = "${var.tenantId}"
    },{
      name  = "SERVICES_STORAGE_URL",
      value = "${module.container-app-services-storage.application_caf_url}"
    }]
}

module "container-app-services-chat" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/services/chat:1.0.26"
  depends_on                    = [ module.container-app-environment, module.main-database, module.redis-cache ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "services"
  application_name              = "chat"
  dapr_name                     = "ms-chat"
  max_replicas                  = 1
  http_port                     = 4000
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [{
      name  = "API_PORT",
      value = "4000"
    },{
      name  = "API_HOST",
      value = "0.0.0.0"
    },{
      name  = "LOG_LEVEL",
      value = "debug"
    },{
      name  = "NODE_ENV",
      value = "production"
    },{
      name  = "DATABASE_URL",
      value = "${module.main-database.connectionstring}"
    },{
      name  = "AZURE_TENANT_ID",
      value = "${var.tenantId}"
    },{
      name  = "CONVERSATIONAL_URL",
      value = "${module.container-app-services-personas.application_caf_url}"
    },{
      name  = "SERVICES_PERSONAS_URL",
      value = "${module.container-app-services-personas.application_caf_url}"
    },{
      name  = "SERVICES_LLM_URL",
      value = "${module.container-app-services-llm.application_caf_url}"
    },{
      name  = "SERVICES_GLOBAL_URL",
      value = "${module.container-app-services-global.application_caf_url}"
    },{
      name  = "REDIS_URL",
      value = "${module.redis-cache.redis_cache_host}"
    },{
      name  = "REDIS_PORT",
      value = "${module.redis-cache.redis_cache_port}"
    },{
      name  = "REDIS_PASSWORD",
      value = "${module.redis-cache.redis_cache_key}"
    },{
      name  = "REDIS_SSL",
      value = "${module.redis-cache.redis_cache_ssl}"
    }]
}

module "container-app-apps-hub" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/apps/conversational:1.0.48"
  depends_on                    = [ module.container-app-environment, module.container-app-services-personas, module.container-app-services-chat, module.container-app-services-global ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "apps"
  application_name              = "hub"
  dapr_name                     = "app-hub"
  http_port                     = 3000
  max_replicas                  = 1
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [
    {
      name  = "NEXTAUTH_SECRET",
      value = "${var.nextauth_secret}"
    },
    {
      name  = "PORT",
      value = "3000"
    },
    {
      name  = "AZURE_AD_CLIENT_ID",
      value = "${var.azure_ad_client_id}"
    },
    {
      name  = "AZURE_AD_CLIENT_SECRET",
      value = "${var.azure_ad_client_secret}"
    },
    {
      name  = "AZURE_AD_TENANT_ID",
      value = "${var.tenantId}"
    },
    {
      name  = "NEXTAUTH_URL",
      value = "TBD"
    },
    {
      name  = "SERVICES_PERSONAS_URL",
      value = "https://${module.container-app-services-personas.application_caf_url}"
    },
    {
      name  = "SERVICES_CHAT_URL",
      value = "https://${module.container-app-services-chat.application_caf_url}"
    },
    {
      name  = "SERVICES_GLOBAL_URL",
      value = "https://${module.container-app-services-global.application_caf_url}"
    }
  ]
}

module "container-app-studio" {
  source                        = "./modules/container-apps"
  docker_image                  = "acrgenaiwsdev.azurecr.io/apps/portal:1.0.31"
  depends_on                    = [ module.container-app-environment ]
  container_app_environment_id  = module.container-app-environment.container-apps-environment-id
  resource_group                = var.resource_group_name
  client_name                   = var.client_name
  project_name                  = var.project_name
  application_group             = "apps"
  application_name              = "studio"
  dapr_name                     = "app-studio"
  http_port                     = 3000
  max_replicas                  = 1
  environment                   = local.environment
  location                      = var.location
  allowedOrigins                = ["*"] 
  container_registry            = {
    admin_password  = var.container_registry_admin_password
    login_server    = var.container_registry_login_server
    admin_username  = var.container_registry_admin_username 
  }
  environment_variables         = [
    {
      name  = "NEXTAUTH_SECRET",
      value = "${var.nextauth_secret}"
    },
    {
      name  = "PORT",
      value = "3000"
    },
    {
      name  = "AZURE_AD_CLIENT_ID",
      value = "${var.azure_ad_client_id}"
    },
    {
      name  = "AZURE_AD_CLIENT_SECRET",
      value = "${var.azure_ad_client_secret}"
    },
    {
      name  = "AZURE_AD_TENANT_ID",
      value = "${var.tenantId}"
    },
    {
      name  = "NEXTAUTH_URL",
      value = "TBD"
    },
    {
      name  = "SERVICES_PERSONAS_URL",
      value = "https://${module.container-app-services-personas.application_caf_url}"
    },
    {
      name  = "SERVICES_LLM_URL",
      value = "https://${module.container-app-services-llm.application_caf_url}"
    },
    {
      name  = "SERVICES_GLOBAL_URL",
      value = "https://${module.container-app-services-global.application_caf_url}"
    }, {
      name  = "SERVICES_STORAGE_URL",
      value = "https://${module.container-app-services-storage.application_caf_url}"
    },
    {
      name  = "SERVICES_DATASOURCES_URL",
      value = "https://${module.container-app-services-datasources.application_caf_url}"
    }
  ]
}


