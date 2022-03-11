# Helm provider
provider "elastic-helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
}

# Kubernetes provider
provider "elastic-kubernetes" {
  config_path = var.kubernetes_config_path
}

provider "elastic-kubectl" {
  config_path = var.kubernetes_config_path
}
