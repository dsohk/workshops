## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 2.88.1 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.7.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.1.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 1.22.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.88.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_rancher2.admin"></a> [rancher2.admin](#provider\_rancher2.admin) | 1.22.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.2 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.7.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_harbor"></a> [harbor](#module\_harbor) | ../../../terraform-modules/harbor | n/a |
| <a name="module_jenkins"></a> [jenkins](#module\_jenkins) | ../../../terraform-modules/jenkins | n/a |
| <a name="module_neuvector"></a> [neuvector](#module\_neuvector) | ../../../terraform-modules/neuvector | n/a |
| <a name="module_nfs_server_provisioner"></a> [nfs\_server\_provisioner](#module\_nfs\_server\_provisioner) | ../../../terraform-modules/nfs-server-provisioner | n/a |
| <a name="module_rancher_server"></a> [rancher\_server](#module\_rancher\_server) | ../../../terraform-modules/rancher | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.rancher_server](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.rke2_node](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.rancher-server-nic](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/network_interface) | resource |
| [azurerm_network_interface.rke2-nodes-nic](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/network_interface) | resource |
| [azurerm_public_ip.rancher-server-pip](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/public_ip) | resource |
| [azurerm_public_ip.rke2-nodes-pip](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rancher](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/resource_group) | resource |
| [azurerm_subnet.rancher-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/subnet) | resource |
| [azurerm_subnet.rke2-subnet](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/subnet) | resource |
| [azurerm_virtual_network.rancher](https://registry.terraform.io/providers/hashicorp/azurerm/2.88.1/docs/resources/virtual_network) | resource |
| [local_file.rke2_clusters_kubeconfig](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [local_file.ssh_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [local_file.ssh_public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [local_file.ssh_to_rancher_server](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [local_file.ssh_to_rke2_clusters](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [rancher2_cluster_v2.rke2_clusters](https://registry.terraform.io/providers/rancher/rancher2/1.22.2/docs/resources/cluster_v2) | resource |
| [random_password.rancher_server_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_sleep.wait_rke2_cluster_initialized_for_10mins](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [tls_private_key.global_key](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_add_windows_node"></a> [add\_windows\_node](#input\_add\_windows\_node) | Add a windows node to the workload cluster | `bool` | `false` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure client id used to create resources | `string` | n/a | yes |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Client secret used to authenticate with Azure apis | `string` | n/a | yes |
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location used for all resources | `string` | `"Central India"` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription id under which resources will be provisioned | `string` | n/a | yes |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant id used to create resources | `string` | n/a | yes |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside Rancher (format: 0.0.0) | `string` | `"1.7.0"` | no |
| <a name="input_no_of_downstream_clusters"></a> [no\_of\_downstream\_clusters](#input\_no\_of\_downstream\_clusters) | Specify number of All In One RKE2 clusters | `number` | `1` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"lab"` | no |
| <a name="input_rancher_server_use_static_public_ip"></a> [rancher\_server\_use\_static\_public\_ip](#input\_rancher\_server\_use\_static\_public\_ip) | Indicate if static public ip should be allocated to rancher server | `bool` | `false` | no |
| <a name="input_rancher_server_vm_size"></a> [rancher\_server\_vm\_size](#input\_rancher\_server\_vm\_size) | Instance type used for all linux virtual machines | `string` | `"Standard_B2ms"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher server version (format: v0.0.0) | `string` | `"v2.6.3"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource Group Name | `string` | `"attendee1"` | no |
| <a name="input_rke2_node_vm_size"></a> [rke2\_node\_vm\_size](#input\_rke2\_node\_vm\_size) | Instance type used for all linux virtual machines | `string` | `"Standard_B4ms"` | no |
| <a name="input_tag_department"></a> [tag\_department](#input\_tag\_department) | Department (as tag) | `string` | `"My Department"` | no |
| <a name="input_tag_environment"></a> [tag\_environment](#input\_tag\_environment) | Stakeholder (as tag) | `string` | `"Test"` | no |
| <a name="input_tag_group"></a> [tag\_group](#input\_tag\_group) | Group (as tag) | `string` | `"My Group"` | no |
| <a name="input_tag_project"></a> [tag\_project](#input\_tag\_project) | Project (as tag) | `string` | `"Demo"` | no |
| <a name="input_tag_resource_owner"></a> [tag\_resource\_owner](#input\_tag\_resource\_owner) | Owner for the resource (as tag) | `string` | `"you@email.com"` | no |
| <a name="input_tag_stakeholder"></a> [tag\_stakeholder](#input\_tag\_stakeholder) | Stakeholder (as tag) | `string` | `"Manager Name"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_harbor_password"></a> [harbor\_password](#output\_harbor\_password) | n/a |
| <a name="output_harbor_url"></a> [harbor\_url](#output\_harbor\_url) | n/a |
| <a name="output_harbor_user"></a> [harbor\_user](#output\_harbor\_user) | n/a |
| <a name="output_jenkins_password"></a> [jenkins\_password](#output\_jenkins\_password) | n/a |
| <a name="output_jenkins_url"></a> [jenkins\_url](#output\_jenkins\_url) | n/a |
| <a name="output_jenkins_user"></a> [jenkins\_user](#output\_jenkins\_user) | n/a |
| <a name="output_neuvector_password"></a> [neuvector\_password](#output\_neuvector\_password) | n/a |
| <a name="output_neuvector_user"></a> [neuvector\_user](#output\_neuvector\_user) | n/a |
| <a name="output_neuvector_webui_url"></a> [neuvector\_webui\_url](#output\_neuvector\_webui\_url) | n/a |
| <a name="output_rancher_server_password"></a> [rancher\_server\_password](#output\_rancher\_server\_password) | n/a |
| <a name="output_rancher_server_url"></a> [rancher\_server\_url](#output\_rancher\_server\_url) | n/a |
| <a name="output_rancher_server_user"></a> [rancher\_server\_user](#output\_rancher\_server\_user) | n/a |
