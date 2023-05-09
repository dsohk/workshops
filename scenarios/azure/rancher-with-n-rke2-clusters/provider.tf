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
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
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

provider "azurerm" {
  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id

  features {}
}

provider "tls" {
}

provider "kubernetes" {
  config_path = module.rancher_server.rancher_rke2_kubeconfig_filepath
}

provider "helm" {
  kubernetes {
    config_path = module.rancher_server.rancher_rke2_kubeconfig_filepath
  }
}

provider "rancher2" {
  alias = "admin"

  api_url  = module.rancher_server.rancher_url
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  token_key = module.rancher_server.rancher_admin_token
}