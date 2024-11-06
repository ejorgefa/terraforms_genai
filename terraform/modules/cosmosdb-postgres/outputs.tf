output "connectionstring" {
   value = "postgres://citus:${var.database_admin_password}@${azurerm_cosmosdb_postgresql_cluster.cluster.servers[0].fqdn}:5432/citus?sslmode=require"
   sensitive   = true
}