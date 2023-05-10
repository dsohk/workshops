# Neuvector terraform module

This `neuvector` terraform module helps manage resources required to deploy 
neuvector on a Kubernetes cluster.


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ingress_host"></a> [ingress\_host](#input\_ingress\_host) | hostname for ingress controller | `string` | n/a | yes |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | config path connecting to the kubernetes cluster where neuvector is target to deploy to | `string` | n/a | yes |
| <a name="input_neuvector_sslcert_path"></a> [neuvector\_sslcert\_path](#input\_neuvector\_sslcert\_path) | output path for neuvector SSL cert (private key and cert) | `string` | n/a | yes |
| <a name="input_neuvector_depends_on"></a> [neuvector\_depends\_on](#input\_neuvector\_depends\_on) | n/a | `any` | `[]` | no |
| <a name="input_neuvector_helm_chart_version"></a> [neuvector\_helm\_chart\_version](#input\_neuvector\_helm\_chart\_version) | Version of neuvector to install (format: 0.0.0) | `string` | `"2.2.2"` | no |
| <a name="input_neuvector_version"></a> [neuvector\_version](#input\_neuvector\_version) | Version of neuvector to install (format: 0.0.0) | `string` | `"5.0.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_neuvector_password"></a> [neuvector\_password](#output\_neuvector\_password) | Neuvector admin initial password |
| <a name="output_neuvector_user"></a> [neuvector\_user](#output\_neuvector\_user) | Neuvector admin username |
| <a name="output_neuvector_webui_url"></a> [neuvector\_webui\_url](#output\_neuvector\_webui\_url) | Neuvector Web UI URL |
<!-- END_TF_DOCS -->