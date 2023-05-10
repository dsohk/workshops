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

variable "scc_url" {
  type        = string
  description = "SUSE Customer Center (SCC) URL"
  default     = "https://scc.suse.com"
}

variable "scc_reg_email" {
  type        = string
  description = "SUSE Customer Center (SCC) Registration Email"
}

variable "scc_reg_code" {
  type        = string
  description = "SUSE Customer Center (SCC) Registration Code"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
}

variable "tag_resource_owner" {
  type        = string
  description = "Owner for the resource (as tag)"
  default     = "you@email.com"
}

variable "tag_group" {
  type        = string
  description = "Group (as tag)"
  default     = "My Group"
}

variable "tag_department" {
  type        = string
  description = "Department (as tag)"
  default     = "My Department"
}

variable "tag_stakeholder" {
  type        = string
  description = "Stakeholder (as tag)"
  default     = "Manager Name"
}

variable "tag_environment" {
  type        = string
  description = "Stakeholder (as tag)"
  default     = "Test"
}

variable "tag_project" {
  type        = string
  description = "Project (as tag)"
  default     = "Demo"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all linux virtual machines"
  default     = "Standard_B4ms"
}

# Local variables used to reduce repetition
locals {
  node_username = "azureuser"
  base_path = abspath("${path.module}/../..")
}
