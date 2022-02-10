output "rke2_cluster_ip" {
  value = azurerm_public_ip.rke2-lb-pip.ip_address
}

output "elastic_url" {
  value = module.elastic.elastic_url
}

output "kibana_url" {
  value = module.elastic.kibana_url
}

output "elastic_user" {
  value = module.elastic.elastic_user
}

output "elastic_password" {
  value     = module.elastic.elastic_password
  sensitive = true
}

