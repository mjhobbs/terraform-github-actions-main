terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0"
    }
  }

  # Update this block with the location of your terraform state file!
  backend "azurerm" {
    resource_group_name  = "rg-terraform-github-actions-state"
    storage_account_name = "tfghstorage"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  use_oidc = true
}

# Define any Azure resources to be created here. A simple resource group is shown here as a minimal example.
resource "azurerm_resource_group" "rg-aks" {
  name     = var.resource_group_name
  location = var.location
}

#
# Creates a container registry on Azure so that you can publish your Docker images.
#
resource "azurerm_container_registry" "container_registry" {
  name                = var.app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_enabled       = true
  sku                 = "Basic"
}