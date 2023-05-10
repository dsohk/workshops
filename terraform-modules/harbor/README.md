# harbor terraform module

This `harbor` terraform module helps manage resources required to deploy 
harbor on a Kubernetes cluster.


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_harbor_ingress_host"></a> [harbor\_ingress\_host](#input\_harbor\_ingress\_host) | hostname for harbor ingress controller | `string` | n/a | yes |
| <a name="input_harbor_sslcert_path"></a> [harbor\_sslcert\_path](#input\_harbor\_sslcert\_path) | output path for harbor SSL cert (private key and cert) | `string` | n/a | yes |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | config path connecting to the kubernetes cluster where harbor is target to deploy to | `string` | n/a | yes |
| <a name="input_notary_ingress_host"></a> [notary\_ingress\_host](#input\_notary\_ingress\_host) | hostname for notary ingress controller | `string` | n/a | yes |
| <a name="input_harbor_client"></a> [harbor\_client](#input\_harbor\_client) | list of ssh client keys to set the containerd runtime to accept harbor self-signed ssl cert | `list(any)` | `[]` | no |
| <a name="input_harbor_depends_on"></a> [harbor\_depends\_on](#input\_harbor\_depends\_on) | n/a | `any` | `[]` | no |
| <a name="input_harbor_helm_chart_version"></a> [harbor\_helm\_chart\_version](#input\_harbor\_helm\_chart\_version) | Version of harbor to install (format: 0.0.0) | `string` | `"1.6.2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_harbor_password"></a> [harbor\_password](#output\_harbor\_password) | n/a |
| <a name="output_harbor_url"></a> [harbor\_url](#output\_harbor\_url) | n/a |
| <a name="output_harbor_user"></a> [harbor\_user](#output\_harbor\_user) | n/a |
<!-- END_TF_DOCS -->