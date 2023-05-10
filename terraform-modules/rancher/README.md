# Rancher Server Shared Terraform Module

This `rancher` terraform module helps managing resources required to deploy 
an instance of Rancher Server, regardless of the underlying cloud provider. 
The Rancher Server will be running on a given single node with RKE2 installed.

## Variables

###### `node_public_ip`
- **Required**
Public IP of compute node for Rancher Server

###### `node_internal_ip`
- Default: **`""`**
Internal IP of compute node for Rancher Server

###### `node_username`
- **Required**
Username used for SSH access to the Rancher Server node

###### `ssh_private_key_pem`
- **Required**
Private key used for SSH access to the Rancher Server node


###### `rancher_kubernetes_version`
- Default: **`"v1.21.8+k3s1"`**
Kubernetes version to use for Rancher server cluster

###### `cert_manager_version`
- Default: **`"1.7.0"`**
Version of cert-manager to install alongside Rancher (format: `0.0.0`)

###### `rancher_version`
- Default: **`"v2.6.3"`**
Rancher server version (format `v0.0.0`)

###### `rancher_server_dns`
- **Required**
DNS host name of the Rancher server

A DNS name is required to allow successful SSL cert generation.
SSL certs may only be assigned to DNS names, not IP addresses.
Only an IP address could cause the Custom cluster to fail due to mismatching SSL
Subject Names.

###### `admin_password`
- **Required**
Admin password to use for Rancher server bootstrap

Log in to the Rancher server using username `admin` and this password.


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_node_public_ip"></a> [node\_public\_ip](#input\_node\_public\_ip) | Public IP of compute node for Rancher cluster | `string` | n/a | yes |
| <a name="input_node_username"></a> [node\_username](#input\_node\_username) | Username used for SSH access to the Rancher server cluster node | `string` | n/a | yes |
| <a name="input_rancher_server_bootstrap_password"></a> [rancher\_server\_bootstrap\_password](#input\_rancher\_server\_bootstrap\_password) | Rancher Server initial password | `string` | n/a | yes |
| <a name="input_rancher_server_dns"></a> [rancher\_server\_dns](#input\_rancher\_server\_dns) | DNS host name of the Rancher server | `string` | n/a | yes |
| <a name="input_ssh_private_key_pem"></a> [ssh\_private\_key\_pem](#input\_ssh\_private\_key\_pem) | Private key used for SSH access to the Rancher server cluster node | `string` | n/a | yes |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside Rancher (format: 0.0.0) | `string` | `"1.10.0"` | no |
| <a name="input_node_internal_ip"></a> [node\_internal\_ip](#input\_node\_internal\_ip) | Internal IP of compute node for Rancher cluster | `string` | `""` | no |
| <a name="input_rancher_depends_on"></a> [rancher\_depends\_on](#input\_rancher\_depends\_on) | n/a | `any` | `[]` | no |
| <a name="input_rancher_helm_repo"></a> [rancher\_helm\_repo](#input\_rancher\_helm\_repo) | Rancher helm chart repository URL | `string` | `"https://charts.rancher.com/server-charts/prime"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher server version (format v0.0.0) | `string` | `"v2.7.0"` | no |
| <a name="input_windows_prefered_cluster"></a> [windows\_prefered\_cluster](#input\_windows\_prefered\_cluster) | Activate windows supports for the custom workload cluster | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_admin_token"></a> [rancher\_admin\_token](#output\_rancher\_admin\_token) | n/a |
| <a name="output_rancher_rke2_kubeconfig_filepath"></a> [rancher\_rke2\_kubeconfig\_filepath](#output\_rancher\_rke2\_kubeconfig\_filepath) | n/a |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | n/a |
<!-- END_TF_DOCS -->