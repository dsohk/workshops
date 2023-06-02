# Azure Infrastructure Resources

# Resource group containing all resources
resource "azurerm_resource_group" "linux" {
  name     = "${var.prefix}-${var.resource_group_name}"
  location = var.azure_location

  tags = {
    Resource_owner = var.tag_resource_owner
  }
}

# Azure virtual network space for the resource group
resource "azurerm_virtual_network" "linux" {
  name                = "${var.prefix}-linux-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.linux.location
  resource_group_name = azurerm_resource_group.linux.name
}

# Azure subnet for linux server
resource "azurerm_subnet" "linux-subnet" {
  name                 = "linux-subnet"
  resource_group_name  = azurerm_resource_group.linux.name
  virtual_network_name = azurerm_virtual_network.linux.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Public IP of Linux server
resource "azurerm_public_ip" "linux-nodes-pip" {
  count               = length(var.server_config)
  name                = format("linux-node%d-pip", count.index + 1)
  location            = azurerm_resource_group.linux.location
  resource_group_name = azurerm_resource_group.linux.name
  allocation_method   = var.use_static_public_ip ? "Static" : "Dynamic"
}

# Azure network interface for linux server
resource "azurerm_network_interface" "linux-nodes-nic" {
  count               = length(var.server_config)
  name                = format("linux-node%d-nic", count.index + 1)
  location            = azurerm_resource_group.linux.location
  resource_group_name = azurerm_resource_group.linux.name

  ip_configuration {
    name                          = format("linux-node%d_ip_config", count.index + 1)
    subnet_id                     = azurerm_subnet.linux-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux-nodes-pip[count.index].id
  }
}

# Rancher bootstrap password
resource "random_password" "linux_server_password" {
  count            = length(var.server_config)
  length           = 12
  special          = true
  override_special = "_%@"
}

# Azure linux virtual machine
resource "azurerm_linux_virtual_machine" "linux_node" {
  count                           = length(var.server_config)
  name                            = var.server_config[count.index].name
  computer_name                   = format("linux-node%d", count.index + 1) // ensure computer_name meets 15 character limit
  location                        = azurerm_resource_group.linux.location
  resource_group_name             = azurerm_resource_group.linux.name
  network_interface_ids           = [azurerm_network_interface.linux-nodes-nic[count.index].id]
  size                            = var.server_config[count.index].size
  admin_username                  = local.node_username
  admin_password                  = random_password.linux_server_password[count.index].result
  disable_password_authentication = false

  source_image_reference {
    publisher = "SUSE"
    offer     = "opensuse-leap-15-4"
    sku       = "gen2"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 60
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
      "sudo zypper ar -G -f https://download.opensuse.org/repositories/home:/ecsos:/server/15.4/ cockpit",
      "sudo zypper -n install -y cockpit",
      "sudo systemctl enable --now cockpit.socket",
      #"sudo sed -ie \"s/PermitRootLogin yes/PermitRootLogin no/g\" /etc/ssh/sshd_config"
      #"sudo systemctl restart sshd"
    ]

    connection {
      type     = "ssh"
      host     = self.public_ip_address
      user     = local.node_username
      password = self.admin_password
    }
  }
}

