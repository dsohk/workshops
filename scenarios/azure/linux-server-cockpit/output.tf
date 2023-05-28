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
}

output "cockpit_server_password" {
  value     = azurerm_linux_virtual_machine.linux_node.*.admin_password
  sensitive = true
}

output "cockpit_webui_url" {
  value       = format("https://%s:9090", azurerm_linux_virtual_machine.linux_node.*.public_ip_address)
  description = "Cockpit Web UI URL"
}