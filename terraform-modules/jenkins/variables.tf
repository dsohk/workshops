# Variables for jenkins terraform module

# Required
variable "kubernetes_config_path" {
  type        = string
  description = "config path connecting to the kubernetes cluster where jenkins is target to deploy to"
}

variable "jenkins_sslcert_path" {
  type        = string
  description = "output path for jenkins SSL cert (private key and cert)"
}

variable "jenkins_helm_chart_version" {
  type        = string
  description = "Version of jenkins to install (format: 0.0.0)"
  default     = "1.6.2"
}

variable "jenkins_ingress_host" {
  type        = string
  description = "hostname for jenkins ingress controller"
}

variable "jenkins_depends_on" {
  type    = any
  default = []
}

