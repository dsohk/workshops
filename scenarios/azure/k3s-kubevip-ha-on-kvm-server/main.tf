# Setup KVM Server
module "kvm-server" {
  source                = "./modules/kvm-server"
  azure_subscription_id = var.azure_subscription_id
  azure_tenant_id       = var.azure_tenant_id
  azure_client_id       = var.azure_client_id
  azure_client_secret   = var.azure_client_secret
  azure_location        = var.azure_location
  scc_url               = var.scc_url
  scc_reg_email         = var.scc_reg_email
  scc_reg_code          = var.scc_reg_code
  resource_group_name   = var.resource_group_name
  instance_type         = var.instance_type
  tag_resource_owner    = var.tag_resource_owner
  tag_group             = var.tag_group
  tag_department        = var.tag_department
  tag_stakeholder       = var.tag_stakeholder
  tag_environment       = var.tag_environment
  tag_project           = var.tag_project
}

# module "k3s-vm" {
#   source          = "./modules/k3s-vm"
#   this_depends_on = [module.kvm-server]
#   kvm_server_uri  = "qemu+ssh://azureuser@${module.kvm-server.kvm_server_ip}/system?keyfile=id_rsa&sshauth=privkey"
# }

