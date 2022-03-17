# Variables for harbor terraform module

# Required
variable "kubernetes_config_path" {
  type        = string
  description = "config path connecting to the kubernetes cluster where harbor is target to deploy to"
}

# Required
variable "harbor_sslcert_path" {
  type = string
  description = "output path for harbor SSL cert (private key and cert)"
}

variable "harbor_helm_chart_version" {
  type        = string
  description = "Version of harbor to install (format: 0.0.0)"
  default     = "1.6.2"
}

variable "harbor_ingress_host" {
  type        = string
  description = "hostname for harbor ingress controller"
}

variable "notary_ingress_host" {
  type        = string
  description = "hostname for notary ingress controller"
}

variable "harbor_depends_on" {
  type    = any
  default = []
}

