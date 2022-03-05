output "rancher_server_url" {
  value = format("https://%s", local.rancher_server_dns)
}

output "rancher_server_ip" {
  value = azurerm_public_ip.rke2-lb-pip.ip_address
}

output "rancher_server_password" {
  value     = local.rancher_password
  sensitive = true
}