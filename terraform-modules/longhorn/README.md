# Longhorn terraform module

This `longhorn` terraform module helps manage resources required to deploy 
longhorn on a Kubernetes cluster.


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | config path connecting to the kubernetes cluster where longhorn is target to deploy to | `string` | n/a | yes |
| <a name="input_longhorn_depends_on"></a> [longhorn\_depends\_on](#input\_longhorn\_depends\_on) | n/a | `any` | `[]` | no |
| <a name="input_longhorn_version"></a> [longhorn\_version](#input\_longhorn\_version) | Version of longhorn to install (format: 0.0.0) | `string` | `"1.3.2"` | no |
| <a name="input_persistence_default_class_replica_count"></a> [persistence\_default\_class\_replica\_count](#input\_persistence\_default\_class\_replica\_count) | Longhorn's Default Class Replica Count (default: 3) | `number` | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_storage_class_name"></a> [storage\_class\_name](#output\_storage\_class\_name) | n/a |
<!-- END_TF_DOCS -->