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
