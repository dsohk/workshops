#! /bin/bash

terraform state list | grep rancher2_cluster_v2.rke2 | xargs terraform state rm
terraform state list | grep rancher2_machine_config_v2 | xargs terraform state rm
terraform state list | grep module.rancher_server.rancher2_bootstrap.admin | xargs terraform state rm
terraform state list | grep module.rancher_server.helm_release.rancher_server | xargs terraform state rm
terraform state list | grep module.rancher_server.helm_release.cert_manager | xargs terraform state rm
terraform state list | grep rancher2_cloud_credential | xargs terraform state rm
terraform destroy --auto-approve

# module.aws_iam_rke.aws_iam_policy.rke_iam_policy_master: Destroying... [id=arn:aws:iam::138310932248:policy/rke_iam_policy_master]
# module.aws_iam_rke.aws_iam_policy.rke_iam_policy_worker: Destroying... [id=arn:aws:iam::138310932248:policy/rke_iam_policy_worker]

# aws iam remove-role-from-instance-profile --instance-profile-name rke_master_iam_instance_profile --role-name rke_iam_role_master
# aws iam remove-role-from-instance-profile --instance-profile-name rke_worker_iam_instance_profile --role-name rke_iam_role_worker
# aws iam delete-role --role-name rke_iam_role_master
# aws iam delete-role --role-name rke_iam_role_worker
# aws iam delete-policy --policy-name rke_iam_policy_master
# aws iam delete-policy --policy-name rke_iam_policy_worker
# aws iam delete-instance-profile --instance-profile-name rke_master_iam_instance_profile
# aws iam delete-instance-profile --instance-profile-name rke_worker_iam_instance_profile
