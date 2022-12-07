resource "azurerm_resource_group" "easyurl-prod-rg" {
  name     = "easyurl-prod-rg"
  location = "North Europe"
}

# Create the Linux App Service Plan
resource "azurerm_service_plan" "appserviceplan" {
  name                = "webapp-asp-easyurl-prod"
  location            = azurerm_resource_group.easyurl-prod-rg.location
  resource_group_name = azurerm_resource_group.easyurl-prod-rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_linux_web_app" "webapp" {
  name                  = "webapp-easyurl-prod"
  location              = azurerm_resource_group.easyurl-prod-rg.location
  resource_group_name   = azurerm_resource_group.easyurl-prod-rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = false
  site_config { 
    minimum_tls_version = "1.2"
  }
}