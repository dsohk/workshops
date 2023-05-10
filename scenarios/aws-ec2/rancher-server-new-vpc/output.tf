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

output "aws_instance_profile_master" {
  value = module.aws_iam_rke.rke_master_iam_instance_profile
}

output "aws_instance_profile_worker" {
  value = module.aws_iam_rke.rke_worker_iam_instance_profile
}

# output "fsid" {
#   value = aws_efs_file_system.rke2_efs.id
# }