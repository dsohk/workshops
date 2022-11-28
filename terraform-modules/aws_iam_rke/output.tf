output "rke_iam_role_master_name" {
  value = aws_iam_role.rke_iam_role_master.name
}

output "rke_iam_role_worker_name" {
  value = aws_iam_role.rke_iam_role_worker.name
}

output "rke_iam_role_aio_name" {
  value = aws_iam_role.rke_iam_role_aio.name
}

output "rke_master_iam_instance_profile" {
  value = aws_iam_instance_profile.rke_master_iam_instance_profile.name
}

output "rke_worker_iam_instance_profile" {
  value = aws_iam_instance_profile.rke_worker_iam_instance_profile.name
}

