# jenkins terraform module

This `jenkins` terraform module helps manage resources required to deploy 
jenkins on a Kubernetes cluster.


<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_jenkins_ingress_host"></a> [jenkins\_ingress\_host](#input\_jenkins\_ingress\_host) | hostname for jenkins ingress controller | `string` | n/a | yes |
| <a name="input_jenkins_sslcert_path"></a> [jenkins\_sslcert\_path](#input\_jenkins\_sslcert\_path) | output path for jenkins SSL cert (private key and cert) | `string` | n/a | yes |
| <a name="input_kubernetes_config_path"></a> [kubernetes\_config\_path](#input\_kubernetes\_config\_path) | config path connecting to the kubernetes cluster where jenkins is target to deploy to | `string` | n/a | yes |
| <a name="input_jenkins_depends_on"></a> [jenkins\_depends\_on](#input\_jenkins\_depends\_on) | n/a | `any` | `[]` | no |
| <a name="input_jenkins_helm_chart_version"></a> [jenkins\_helm\_chart\_version](#input\_jenkins\_helm\_chart\_version) | Version of jenkins to install (format: 0.0.0) | `string` | `"3.5.14"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jenkins_password"></a> [jenkins\_password](#output\_jenkins\_password) | n/a |
| <a name="output_jenkins_url"></a> [jenkins\_url](#output\_jenkins\_url) | n/a |
| <a name="output_jenkins_user"></a> [jenkins\_user](#output\_jenkins\_user) | n/a |
<!-- END_TF_DOCS -->