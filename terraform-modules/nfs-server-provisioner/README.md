# Longhorn terraform module

This `longhorn` terraform module helps manage resources required to deploy 
longhorn on a Kubernetes cluster.


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | config path connecting to the kubernetes cluster where nfs-server-provisioner is target to deploy to | `string` | n/a | yes |
| <a name="input_nfs_server_depends_on"></a> [nfs\_server\_depends\_on](#input\_nfs\_server\_depends\_on) | n/a | `any` | `[]` | no |
| <a name="input_nfs_server_version"></a> [nfs\_server\_version](#input\_nfs\_server\_version) | nfs server provisioner chart version | `string` | `"1.4.0"` | no |
| <a name="input_storageclass_defaultclass"></a> [storageclass\_defaultclass](#input\_storageclass\_defaultclass) | set as default storageclass | `string` | `"true"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_class_name"></a> [storage\_class\_name](#output\_storage\_class\_name) | n/a |
<!-- END_TF_DOCS -->