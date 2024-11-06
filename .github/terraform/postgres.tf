resource "random_password" "cosmosdb_postgresql_passwords" {
  length           = 24
  min_upper        = 6
  min_lower        = 4
  min_numeric      = 6
  special          = false

  depends_on = [
    module.log-analytics-workspace
  ]
}


module "main-database" {
  source                      = "./modules/cosmosdb-postgres"
  depends_on                  = [ module.log-analytics-workspace, random_password.cosmosdb_postgresql_passwords ]
  resource_group              = var.resource_group_name
  client_name                 = var.client_name
  project_name                = var.project_name
  application_name            = "core"
  environment                 = local.environment
  location                    = var.location
  database_admin_password     = random_password.cosmosdb_postgresql_passwords.result
}

# output "db" {
#   value = nonsensitive(module.main-database.connectionstring)
# }