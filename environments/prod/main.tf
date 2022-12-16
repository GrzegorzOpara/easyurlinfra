resource "azurerm_resource_group" "easyurl-prod-rg" {
  name     = "easyurl-prod-rg"
  location = "North Europe"
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-easyurl-be-prod"
  location            = azurerm_resource_group.easyurl-prod-rg.location
  resource_group_name = azurerm_resource_group.easyurl-prod-rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "webapp-easyurl-be-prod"
  location              = azurerm_resource_group.easyurl-prod-rg.location
  resource_group_name   = azurerm_resource_group.easyurl-prod-rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = false
  site_config { 
    minimum_tls_version = "1.2"
      application_stack {
        python_version = "3.9"
      }
  }
  lifecycle {
    ignore_changes = [
        app_settings
    ]
  }
}

# Create storage account and containers for static files 
resource "azurerm_storage_account" "easyurlbestatic" {
  name                     = "easyurlbestatic"
  location                 = azurerm_resource_group.easyurl-prod-rg.location
  resource_group_name      = azurerm_resource_group.easyurl-prod-rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "media" {
  name                  = "media"
  storage_account_name  = azurerm_storage_account.easyurlbestatic.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "static" {
  name                  = "static"
  storage_account_name  = azurerm_storage_account.easyurlbestatic.name
  container_access_type = "blob"
}

resource "azurerm_static_site" "static-web-app" {
  name                = "easyurl-static-web-app"
  location                 = "West Europe"
  resource_group_name      = azurerm_resource_group.easyurl-prod-rg.name
}