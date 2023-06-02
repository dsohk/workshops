/* output "linux_server" {
  value = tomap({
      "URL" = azurerm_linux_virtual_machine.linux_node.*.public_ip_address,
      "user" = azurerm_linux_virtual_machine.linux_node.*.admin_username,
      "pass" = azurerm_linux_virtual_machine.linux_node.*.admin_password,
    })
} */

output "linux_server_cockput_url" {
  value       = [for vm in azurerm_linux_virtual_machine.linux_node.* : "https://${vm.name}.${vm.public_ip_address}.sslip.io:9090"]
  description = "Linux Node Cockpit Web UI URL"
}

output "linux_server_user" {
  value       = azurerm_linux_virtual_machine.linux_node.*.admin_username
  description = "User"
}

output "linux_server_password" {
  value       = azurerm_linux_virtual_machine.linux_node.*.admin_password
  sensitive   = true
  description = "Password"
}