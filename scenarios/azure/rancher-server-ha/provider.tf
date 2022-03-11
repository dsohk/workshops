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
provider "helm" {
  kubernetes {
    config_path = local_file.kube_config_server_yaml.filename
  }
}

# Rancher2 bootstrapping provider
provider "rancher2" {
  alias = "bootstrap"

  api_url  = format("https://%s", local.rancher_server_dns)
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  bootstrap = true
}

provider "rancher2" {
  alias = "admin"

  api_url  = format("https://%s", local.rancher_server_dns)
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  token_key = var.rancher_admin_token
}
