## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure client id used to create resources | `string` | n/a | yes |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Client secret used to authenticate with Azure apis | `string` | n/a | yes |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription id under which resources will be provisioned | `string` | n/a | yes |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant id used to create resources | `string` | n/a | yes |
| <a name="input_add_windows_node"></a> [add\_windows\_node](#input\_add\_windows\_node) | Add a windows node to the workload cluster | `bool` | `false` | no |
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location used for all resources | `string` | `"Central India"` | no |
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
| <a name="output_neuvector_password"></a> [neuvector\_password](#output\_neuvector\_password) | n/a |
| <a name="output_neuvector_user"></a> [neuvector\_user](#output\_neuvector\_user) | n/a |
| <a name="output_neuvector_webui_url"></a> [neuvector\_webui\_url](#output\_neuvector\_webui\_url) | n/a |
| <a name="output_rancher_server_password"></a> [rancher\_server\_password](#output\_rancher\_server\_password) | n/a |
| <a name="output_rancher_server_url"></a> [rancher\_server\_url](#output\_rancher\_server\_url) | n/a |
| <a name="output_rancher_server_user"></a> [rancher\_server\_user](#output\_rancher\_server\_user) | n/a |
