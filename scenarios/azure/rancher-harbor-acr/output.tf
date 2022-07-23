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

output "harbor_url" {
  value = module.harbor.harbor_url
}

output "harbor_user" {
  value = module.harbor.harbor_user
}

output "harbor_password" {
  sensitive = true
  value     = module.harbor.harbor_password
}

output "acr_url" {
  value = azurerm_container_registry.myregistry.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.myregistry.admin_username
}

output "acr_admin_password" {
  sensitive = true
  value     = azurerm_container_registry.myregistry.admin_password
}

