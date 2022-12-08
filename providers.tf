terraform {
    required_providers {
        azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.34.0"
        }
    }
    backend "azurerm" {
        resource_group_name  = var.TF_STATE_RG
        storage_account_name = var.TF_STATE_SA
        container_name       = var.TF_STATE_CN
        key                  = var.TF_STATE_KEY
    }
}

provider "azurerm" {
  features {}
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
  tenant_id       = var.ARM_TENANT_ID
}
