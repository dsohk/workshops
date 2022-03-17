# Variables for longhorn terraform module

# Required
variable "kubernetes_config_path" {
  type        = string
  description = "config path connecting to the kubernetes cluster where longhorn is target to deploy to"
}

variable "longhorn_version" {
  type        = string
  description = "Version of longhorn to install (format: 0.0.0)"
  default     = "1.2"
}

variable "persistence_default_class_replica_count" {
  type        = number
  description = "Longhorn's Default Class Replica Count (default: 3)"
  default     = 3
}

variable "longhorn_depends_on" {
  type    = any
  default = []
}