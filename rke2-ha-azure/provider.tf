provider "azurerm" {
  features {}

  subscription_id = var.azure_subscription_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

provider "tls" {
}

# Helm provider
# provider "helm" {
#   kubernetes {
#     config_path = module.rancher_server.rancher_rke2_kubeconfig_filepath
#   }
# }
