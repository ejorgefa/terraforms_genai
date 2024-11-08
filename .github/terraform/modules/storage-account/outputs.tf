output "name" {
  value       = azurerm_storage_account.tfstate.name
  description = "The "
}

output "key" {
  value       = azurerm_storage_account.tfstate.primary_access_key
  description = "The "
}