# Helm provider
provider "neuvector-helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
}

provider "kubernetes" {
  config_path = var.kubernetes_config_path
}
