# Terraform module to create IAM roles on AWS specific to Rancher/RKE/RKE2 cluster


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rke_iam_role_aio_name"></a> [rke\_iam\_role\_aio\_name](#output\_rke\_iam\_role\_aio\_name) | n/a |
| <a name="output_rke_iam_role_master_name"></a> [rke\_iam\_role\_master\_name](#output\_rke\_iam\_role\_master\_name) | n/a |
| <a name="output_rke_iam_role_worker_name"></a> [rke\_iam\_role\_worker\_name](#output\_rke\_iam\_role\_worker\_name) | n/a |
| <a name="output_rke_master_iam_instance_profile"></a> [rke\_master\_iam\_instance\_profile](#output\_rke\_master\_iam\_instance\_profile) | n/a |
| <a name="output_rke_worker_iam_instance_profile"></a> [rke\_worker\_iam\_instance\_profile](#output\_rke\_worker\_iam\_instance\_profile) | n/a |
<!-- END_TF_DOCS -->