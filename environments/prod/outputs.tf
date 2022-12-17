output "static_storage_account_name" {
  description = "Storage Account name for static content"
  value       = azurerm_storage_account.sastatic.name
}

output "static_storage_account_primary_access_key" {
  description = "Storage Account access key"
  value = azurerm_storage_account.sastatic.primary_access_key
}

output "be_web_app_url" {
    value = "${azurerm_linux_web_app.webapp.name}.azurewebsites.net"
}

output "fe_web_app_url" {
    value = azurerm_static_site.static-web-app.default_host_name
}

output "fe_web_app_api_key" {
    value = azurerm_static_site.static-web-app.api_key
}