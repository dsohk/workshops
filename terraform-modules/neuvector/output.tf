output "neuvector_webui_url" {
  value       = format("https://%s", var.ingress_host)
  description = "Neuvector Web UI URL"
}

output "neuvector_user" {
  value       = "admin"
  description = "Neuvector admin username"
}

output "neuvector_password" {
  value       = "admin"
  description = "Neuvector admin initial password"
}