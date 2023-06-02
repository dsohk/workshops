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
  default     = "Central India"
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

variable "tag_resource_owner" {
  type        = string
  description = "Owner for the resource (as tag)"
  default     = "you@email.com"
}

variable "use_static_public_ip" {
  type        = bool
  description = "Indicate if static public ip should be allocated to linux server"
  default     = true
}

# Local variables used to reduce repetition
locals {
  node_username = "suse"
}

# spec: https://docs.microsoft.com/en-us/azure/virtual-machines/dav4-dasv4-series
# pricing: https://azure.microsoft.com/en-us/pricing/details/virtual-machines/linux/
# $0.0622/hour Central India (2 vCPU AMD, 8GB RAM, 16GB SSD) - Standard_D2as_v4
# $0.0896/hour Central India (2 vCPU AMD, 8GB RAM, 16GB SSD) - Standard_B2ms

# server configuration (hostname and size)
variable "server_config" {
  type = list(object({
    name = string
    size = string
  }))
  default = [
    { name = "rancher", size = "Standard_D4s_v4" },
    { name = "server1", size = "Standard_D4s_v4" }
  ]
}

