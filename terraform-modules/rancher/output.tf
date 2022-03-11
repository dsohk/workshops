# Outputs

output "rancher_url" {
  value = "https://${var.rancher_server_dns}"
}

output "rancher_admin_token" {
  value     = rancher2_bootstrap.admin.token
  sensitive = true
}
output "rancher_rke2_kubeconfig_filepath" {
  value = local_file.kube_config_server_yaml.filename
}