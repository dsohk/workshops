# Variables for nfs-server-provisioner terraform module

# Required
variable "kubernetes_config_path" {
  type        = string
  description = "config path connecting to the kubernetes cluster where nfs-server-provisioner is target to deploy to"
}

variable "nfs_server_version" {
  type        = string
  description = "nfs server provisioner chart version"
  default     = "1.4.0"
}

variable "storageclass_defaultclass" {
  type        = string
  description = "set as default storageclass"
  default     = "true"
}
