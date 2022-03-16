output "harbor_url" {
  value = format("https://%s", var.harbor_ingress_host)
}

output "harbor_user" {
  value = "admin"
}

output "harbor_password" {
  sensitive = true
  value     = random_password.harbor_admin_password.result
}