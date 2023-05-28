output "linux_server" {
  sensitive = true
  value = [
    tomap({
      "Linux_URL" = format("https://%d:9090", flatten(azurerm_linux_virtual_machine.linux_node.*.public_ip_address))
      "User" = azurerm_linux_virtual_machine.linux_node.*.admin_username,
      "Password" = azurerm_linux_virtual_machine.linux_node.*.admin_password,
    })
  ]
}

/* 
output "linux_server_user" {
  value = azurerm_linux_virtual_machine.linux_node.*.admin_username
  description = "User"
}

output "linux_server_password" {
  value     = azurerm_linux_virtual_machine.linux_node.*.admin_password
  sensitive = true
  description = "Password"
}

output "linux_server_ip" {
  value       = azurerm_linux_virtual_machine.linux_node.*.public_ip_address
  description = "Linux Server IP"
}

output "linux_server_cockput_url" {
  value       = format("https://%s:%s",azurerm_linux_virtual_machine.linux_node.*.public_ip_address,"9090")
  description = "Cockpit Web UI URL"
} */