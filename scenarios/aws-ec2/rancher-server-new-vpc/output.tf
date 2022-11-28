output "rancher_server_url" {
  value = module.rancher_server.rancher_url
}

output "rancher_server_ip" {
  value = aws_eip.rancher_server_eip.public_ip
}

output "rancher_server_bootstrap_password" {
  value     = random_password.rancher_server_password.result
  sensitive = true
}

output "fsid" {
  value = aws_efs_file_system.rke2_efs.id
}