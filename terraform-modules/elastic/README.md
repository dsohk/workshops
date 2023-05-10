# ElasticSearch and Kibana (ECK) terraform module

This `elastic` terraform module helps manage resources required to deploy 
ECK on a Kubernetes cluster.


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eck_host"></a> [eck\_host](#input\_eck\_host) | Hostname or IP address of the Kubernetes cluster where ECK is running on | `string` | n/a | yes |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | config path connecting to the kubernetes cluster where ECK is target to deploy to | `string` | n/a | yes |
| <a name="input_eck_version"></a> [eck\_version](#input\_eck\_version) | Elastic Operator version. | `string` | `"1.9.0"` | no |
| <a name="input_es_count"></a> [es\_count](#input\_es\_count) | Number of replicas for ElasticSearch | `number` | `1` | no |
| <a name="input_es_port"></a> [es\_port](#input\_es\_port) | External Port for Elastic NodePort Service | `number` | `30001` | no |
| <a name="input_kb_count"></a> [kb\_count](#input\_kb\_count) | Number of replicas for Kibana | `number` | `1` | no |
| <a name="input_kb_port"></a> [kb\_port](#input\_kb\_port) | External Port for Kibana NodePort Service | `number` | `30002` | no |
| <a name="input_storage_class_name"></a> [storage\_class\_name](#input\_storage\_class\_name) | Persistent Volume Storage Class Name | `string` | `"longhorn"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_elastic_password"></a> [elastic\_password](#output\_elastic\_password) | n/a |
| <a name="output_elastic_url"></a> [elastic\_url](#output\_elastic\_url) | n/a |
| <a name="output_elastic_user"></a> [elastic\_user](#output\_elastic\_user) | n/a |
| <a name="output_kibana_url"></a> [kibana\_url](#output\_kibana\_url) | n/a |
<!-- END_TF_DOCS -->