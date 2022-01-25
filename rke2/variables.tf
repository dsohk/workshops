# Variables for rke2 module

# Required
variable "rancher_server_dns" {
  type        = string
  description = "DNS host name of the Rancher server"
}

# Required
variable "rancher_admin_token" {
  type        = string
  description = "Rancher 2.x admin token"
}

variable "cluster_name" {
  type        = string
  description = "Downstream cluster name"
}

variable "kubernetes_version" {
  type        = string
  description = "Downstream Kubernetes version"
  default     = "v1.20.6-rancher1-1"
}
