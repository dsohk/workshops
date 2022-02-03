output "elastic_user" {
  value = "elastic"
}

output "elastic_password" {
  value     = data.kubernetes_secret.elastic_password.binary_data.elastic
  sensitive = true
}

output "rke2_cluster_ip" {
  value = azurerm_public_ip.rke2-lb-pip.ip_address
}

