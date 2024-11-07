output "redis_cache_host" {
  value       = azurerm_redis_cache.redis.hostname
  description = "The Redis Cache hostname."
}

output "redis_cache_key" {
  value       = azurerm_redis_cache.redis.primary_access_key
  description = "The Redis Cache primary access key."
}

output "redis_cache_port" {
  value       = azurerm_redis_cache.redis.ssl_port
  description = "The redis Cache ssl port."
}

output "redis_cache_ssl" {
  value       = true
  description = "Does the Redis Cache require SSL?"
}
