module "main-aisearch" {
  source                      = "./modules/cognitive-services-aisearch"
  depends_on                  = [ module.log-analytics-workspace ]
  resource_group              = var.resource_group_name
  client_name                 = var.client_name
  project_name                = var.project_name
  environment                 = local.environment
  location                    = var.location
  aisearch                    = {
    partition_count = 1
    replica_count   = 1
    sku             = "basic"
  }
}