# Helm provider
provider "helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
}
