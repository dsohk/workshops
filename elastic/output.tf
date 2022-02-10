
output "elastic_url" {
  value = format("https://%s:%d", var.eck_host, var.es_port)
}

output "kibana_url" {
  value = format("https://%s:%d", var.eck_host, var.kb_port)
}

output "elastic_user" {
  value = "elastic"
}

output "elastic_password" {
  value     = data.kubernetes_secret.elastic_password.data.elastic
  sensitive = true
}

