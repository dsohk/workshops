# Variables for ECK (Elastic Cloud on Kubernetes) terraform module

# Required
variable "kubernetes_config_path" {
  type        = string
  description = "config path connecting to the kubernetes cluster where ECK is target to deploy to"
}

variable "eck_host" {
  type        = string
  description = "Hostname or IP address of the Kubernetes cluster where ECK is running on"
}

variable "eck_version" {
  type        = string
  description = "Elastic Operator version."
  default     = "1.9.0"
}

variable "storage_class_name" {
  type        = string
  description = "Persistent Volume Storage Class Name"
  default     = "longhorn"
}

variable "es_port" {
  type        = number
  description = "External Port for Elastic NodePort Service"
  default     = 30001
}

variable "kb_port" {
  type        = number
  description = "External Port for Kibana NodePort Service"
  default     = 30002
}

