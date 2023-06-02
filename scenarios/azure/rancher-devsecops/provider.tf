provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
  
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