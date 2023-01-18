# Variables for AWS infrastructure module

# Required
variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

# Required
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "lab"
}

variable "tag_owner" {
  type        = string
  description = "Owner for the resource (as tag)"
  default     = "demo"
}

variable "linux_master_instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.large"
}

variable "linux_worker_instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.large"
}

variable "windows_instance_type" {
  type        = string
  description = "Instance type used for all EC2 windows instances"
  default     = "t3a.xlarge"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "v2.7.0"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.10.0"
}

# Required
variable "add_windows_node" {
  type        = bool
  description = "Add a windows node to the workload cluster"
  default     = false
}

# Local variables used to reduce repetition
locals {
  node_username = "ec2-user"
}
