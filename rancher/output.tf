# Outputs

output "rancher_url" {
  value = "https://${var.rancher_server_dns}"
}

output "rancher_admin_token" {
  value = rancher2_bootstrap.admin.token
  sensitive = true
}
