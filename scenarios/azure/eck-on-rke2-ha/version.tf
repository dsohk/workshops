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
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "1.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.24.2"
    }
  }
  required_version = ">= 0.14.9"
}

