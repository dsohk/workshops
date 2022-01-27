output "rancher_server_url" {
  value = module.rancher_server.rancher_url
}

output "rancher_server_ip" {
  value = azurerm_linux_virtual_machine.rancher_server.public_ip_address
}

output "rancher_server_bootstrap_password" {
  value     = random_password.rancher_server_password.result
  sensitive = true
}

output "keycloak_url" {
  value = format("https://%s", join(".", ["keycloak", "${azurerm_linux_virtual_machine.rancher_server.public_ip_address}", "sslip.io"]))
}

output "keycloak_admin_password" {
  value     = random_password.keycloak_admin_password.result
  sensitive = true
}