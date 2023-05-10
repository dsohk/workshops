output "kvm_server_ip" {
  value = azurerm_linux_virtual_machine.kvm_server.public_ip_address
}