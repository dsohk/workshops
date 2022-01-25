# Variables for Azure infrastructure module

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription id under which resources will be provisioned"
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant id used to create resources"
}

variable "azure_client_id" {
  type        = string
  description = "Azure client id used to create resources"
}

variable "azure_client_secret" {
  type        = string
  description = "Client secret used to authenticate with Azure apis"
}

variable "azure_location" {
  type        = string
  description = "Azure location used for all resources"
  default     = "East US"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "lab"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = "attendee1"
}

variable "tag_owner" {
  type        = string
  description = "Owner for the resource (as tag)"
  default     = "demo"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all linux virtual machines"
  default     = "Standard_B4ms"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "v2.6.3"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.5.3"
}

# Required
variable "add_windows_node" {
  type        = bool
  description = "Add a windows node to the workload cluster"
  default     = false
}

# Local variables used to reduce repetition
locals {
  node_username = "azureuser"
}

variable "no_of_downstream_clusters" {
  type        = number
  description = "Specify number of All In One RKE2 clusters"
  default     = 2
}