provider "libvirt" {
  # Configuration options
  alias = "kvm-server"
  # uri = "qemu:///system"
  # uri = "qemu+ssh://ansible@zzzzzz/system?keyfile=/Users/xxxxxx/.ssh/id_rsa"
  # uri = "qemu+ssh://azureuser@${azurerm_linux_virtual_machine.kvm_server.public_ip_address}/system"
  uri = var.kvm_server_uri
}