output "rke2_cluster_ip" {
  value = azurerm_public_ip.rke2-lb-pip.ip_address
}

