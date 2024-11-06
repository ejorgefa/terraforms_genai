module "log-analytics-workspace" {
  source          = "./modules/log-analytics-workspace"
  resource_group  = var.resource_group_name
  client_name     = var.client_name
  project_name    = var.project_name
  environment     = local.environment
  location        = var.location
}