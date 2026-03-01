terraform {
  cloud {
   organization = "azure-lb-test"
   workspaces {
    name = "azure-tfstate-lb"
   }
  }
  required_version = "~> 1.13"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.60"
    }
  }
}