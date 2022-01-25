output "rancher_server_url" {
  value = module.rancher_server.rancher_url
}

output "rancher_server_ip" {
  value = azurerm_linux_virtual_machine.rancher_server.public_ip_address
}

output "rancher_server_bootstrap_password" {
  value     = random_password.rancher_server_password.result
  sensitive = true
}

output "rke2-node-public-ip" {
  value = azurerm_public_ip.rke2-node1-pip.ip_address
}

output "rke2-node-private-ip" {
  value = azurerm_network_interface.rke2-node1-nic.private_ip_address
}

output "reg_cmd" {
  value = module.rke2.custom_cluster_command
  sensitive = true
}