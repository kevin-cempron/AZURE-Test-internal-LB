terraform {
  cloud {
    organization = "azure-lb-test"
    workspaces {
      name = "azure-tfstate-lb"
    }
  }


  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.60"
    }
  }

  required_version = "~> 1.13"
}