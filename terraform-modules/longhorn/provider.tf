# Helm provider
provider "longhorn-helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
}
