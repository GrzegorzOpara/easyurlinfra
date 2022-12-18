locals {
    # List of azure app configuration items to load and set up
    app_config_keys_list = ["DB_NAME", "DB_USER", "DB_PASSWORD", "DB_SERVER", "SECRET_KEY", "CSRF_TRUSTED_ORIGINS", "HOSTS", "DEBUG", "STATIC_AZURE_ACCOUNT_KEY", "STATIC_AZURE_ACCOUNT_NAME", "SCM_DO_BUILD_DURING_DEPLOYMENT", "WEBSITE_ENABLE_SYNC_UPDATE_SITE" ]
}

data "azurerm_app_configuration" "app-config" {
  name                = "${var.project_name}-app-config"
  resource_group_name = "global-app-config-rg"
}

data "azurerm_app_configuration_key" "app-config-data" {
  for_each   = toset(local.app_config_keys_list)
  configuration_store_id = data.azurerm_app_configuration.app-config.id
  key = "${var.project_name}be-${each.key}"
  label = "${var.environment}"
  depends_on = [
    azurerm_app_configuration_key.CSRF_TRUSTED_ORIGINS,
    azurerm_app_configuration_key.HOSTS,
    azurerm_app_configuration_key.STATIC_AZURE_ACCOUNT_KEY,
    azurerm_app_configuration_key.STATIC_AZURE_ACCOUNT_NAME,
  ]
}

# Create main RG
resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = "${var.location}"
}

# Create the Linux App Service Plan for BE
resource "azurerm_service_plan" "appserviceplan" {
  name                = "${var.project_name}-${var.environment}-webapp-asp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

# Create the web app for BE
resource "azurerm_linux_web_app" "webapp" {
  name                  = "${var.project_name}-${var.environment}-webapp-be"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  service_plan_id       = azurerm_service_plan.appserviceplan.id
  https_only            = true
  site_config { 
    minimum_tls_version = "1.2"
      application_stack {
        python_version = "${var.python_version}"
      }
  }
  app_settings = {
    for key in tolist(local.app_config_keys_list) : key => data.azurerm_app_configuration_key.app-config-data["${key}"].value
  }
  depends_on = [
    azurerm_app_configuration_key.STATIC_AZURE_ACCOUNT_NAME,
    azurerm_app_configuration_key.STATIC_AZURE_ACCOUNT_KEY,
    data.azurerm_app_configuration_key.app-config-data["CSRF_TRUSTED_ORIGINS"],
    data.azurerm_app_configuration_key.app-config-data["HOSTS"],
    data.azurerm_app_configuration_key.app-config-data["STATIC_AZURE_ACCOUNT_NAME"],
    data.azurerm_app_configuration_key.app-config-data["STATIC_AZURE_ACCOUNT_KEY"]
  ]
}

# Create storage account and containers for static files 
resource "azurerm_storage_account" "sastatic" {
  name                     = "${var.project_name}${var.environment}sastatic"
  location                 = azurerm_resource_group.rg.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"

}

resource "azurerm_storage_container" "media" {
  name                  = "media"
  storage_account_name  = azurerm_storage_account.sastatic.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "static" {
  name                  = "static"
  storage_account_name  = azurerm_storage_account.sastatic.name
  container_access_type = "blob"
}

# Static web app for FE
resource "azurerm_static_site" "static-web-app" {
  name                = "${var.project_name}-${var.environment}-static-web-app"
  location                 = "West Europe" # has to be hardcoded due to limited location where this services is available
  resource_group_name      = azurerm_resource_group.rg.name
}

# Setting up the azure app configuration
resource "azurerm_app_configuration_key" "STATIC_AZURE_ACCOUNT_NAME" {
  configuration_store_id = data.azurerm_app_configuration.app-config.id
  key                    = "${var.project_name}be-STATIC_AZURE_ACCOUNT_NAME"
  label                  = "${var.environment}"
  value                  = azurerm_storage_account.sastatic.name
}

resource "azurerm_app_configuration_key" "STATIC_AZURE_ACCOUNT_KEY" {
  configuration_store_id = data.azurerm_app_configuration.app-config.id
  key                    = "${var.project_name}be-STATIC_AZURE_ACCOUNT_KEY"
  label                  = "${var.environment}"
  value                  = azurerm_storage_account.sastatic.primary_access_key
}

resource "azurerm_app_configuration_key" "HOSTS" {
  configuration_store_id = data.azurerm_app_configuration.app-config.id
  key                    = "${var.project_name}be-HOSTS"
  label                  = "${var.environment}"
  value                  = "${var.project_name}-${var.environment}-webapp-be.azurewebsites.net"
}

resource "azurerm_app_configuration_key" "CSRF_TRUSTED_ORIGINS" {
  configuration_store_id = data.azurerm_app_configuration.app-config.id
  key                    = "${var.project_name}be-CSRF_TRUSTED_ORIGINS"
  label                  = "${var.environment}"
  value                  = "https://${var.project_name}-${var.environment}-webapp-be.azurewebsites.net"
}

resource "azurerm_app_configuration_key" "FE_WEB_APP_URL" {
  configuration_store_id = data.azurerm_app_configuration.app-config.id
  key                    = "${var.project_name}fe-FE_WEB_APP_URL"
  label                  = "${var.environment}"
  value                  = azurerm_static_site.static-web-app.default_host_name
}

resource "azurerm_app_configuration_key" "FE_WEB_APP_API_KEY" {
  configuration_store_id = data.azurerm_app_configuration.app-config.id
  key                    = "${var.project_name}fe-FE_WEB_API_KEY"
  label                  = "${var.environment}"
  value                  = azurerm_static_site.static-web-app.api_key
}