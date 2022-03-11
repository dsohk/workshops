# Helm provider
provider "nfs-provisioner-helm" {
  kubernetes {
    config_path = var.kubernetes_config_path
  }
}
