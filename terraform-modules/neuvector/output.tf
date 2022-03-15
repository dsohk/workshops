output "neuvector_webui_url" {
  value = format("https://%s", var.ingress_host)
}

output "neuvector_user" {
  value = "admin"
}

output "neuvector_password" {
  value = "admin"
}