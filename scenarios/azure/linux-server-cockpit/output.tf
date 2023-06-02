output "linux_server" {
  value = tomap({
      "URL" = azurerm_linux_virtual_machine.linux_node.*.public_ip_address,
      "user" = azurerm_linux_virtual_machine.linux_node.*.admin_username,
      "pass" = azurerm_linux_virtual_machine.linux_node.*.admin_password,
    })
}
