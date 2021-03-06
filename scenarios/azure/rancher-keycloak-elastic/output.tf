output "rancher_server_url" {
  value = module.rancher_server.rancher_url
}

output "rancher_server_user" {
  value = "admin"
}

output "rancher_server_password" {
  value     = random_password.rancher_server_password.result
  sensitive = true
}

output "keycloak_url" {
  value = format("https://%s", join(".", ["keycloak", "${azurerm_linux_virtual_machine.rancher_server.public_ip_address}", "sslip.io"]))
}

output "keycloak_admin_user" {
  value = "admin"
}

output "keycloak_admin_password" {
  value     = random_password.keycloak_admin_password.result
  sensitive = true
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

