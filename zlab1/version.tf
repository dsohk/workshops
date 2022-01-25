terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.88.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.22.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
  required_version = ">= 0.14.9"
}