/* output "linux_server" {
  sensitive = true
  value = [
    tomap({
      "URL" = azurerm_linux_virtual_machine.linux_node.*.public_ip_address,
      "user" = azurerm_linux_virtual_machine.linux_node.*.admin_username,
      "pass" = azurerm_linux_virtual_machine.linux_node.*.admin_password,
    })
  ]
} */

output "cockpit_server_user" {
  value = azurerm_linux_virtual_machine.linux_node.*.admin_username
  description = "user"
}

output "cockpit_server_password" {
  value     = azurerm_linux_virtual_machine.linux_node.*.admin_password
  sensitive = true
  description = "Password "
}

output "cockpit_webui_url" {
  value       = format("https://%s", azurerm_linux_virtual_machine.linux_node.*.public_ip_address)
  description = "Cockpit Web UI URL"
}