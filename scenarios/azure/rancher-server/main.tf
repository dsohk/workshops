# Azure Infrastructure Resources


# Resource group containing all resources
resource "azurerm_resource_group" "rancher" {
  name     = "${var.prefix}-rancher"
  location = var.azure_location

  tags = {
    Resource_owner = var.tag_resource_owner,
    Group          = var.tag_group,
    Department     = var.tag_department,
    Stakeholder    = var.tag_stakeholder,
    Environment    = var.tag_environment,
    Project        = var.tag_project
  }
}

# Azure virtual network space for the resource group
resource "azurerm_virtual_network" "rancher" {
  name                = "${var.prefix}-rancher-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rancher.location
  resource_group_name = azurerm_resource_group.rancher.name
}

# Azure internal subnet for quickstart resources
resource "azurerm_subnet" "rancher-subnet" {
  name                 = "rancher-subnet"
  resource_group_name  = azurerm_resource_group.rancher.name
  virtual_network_name = azurerm_virtual_network.rancher.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Public IP of Rancher server
resource "azurerm_public_ip" "rancher-server-pip" {
  name                = "rancher-server-pip"
  location            = azurerm_resource_group.rancher.location
  resource_group_name = azurerm_resource_group.rancher.name
  allocation_method   = "Static"
}

# Azure network interface for rancher server
resource "azurerm_network_interface" "rancher-server-nic" {
  name                = "rancher-server-nic"
  location            = azurerm_resource_group.rancher.location
  resource_group_name = azurerm_resource_group.rancher.name

  ip_configuration {
    name                          = "rancher_server_ip_config"
    subnet_id                     = azurerm_subnet.rancher-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rancher-server-pip.id
  }

}

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename          = "${path.module}/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# Azure linux virtual machine for creating a single node RKE cluster and installing the Rancher Server
resource "azurerm_linux_virtual_machine" "rancher_server" {
  name                  = "${var.prefix}-rancher-server"
  computer_name         = "rancher-server" // ensure computer_name meets 15 character limit
  location              = azurerm_resource_group.rancher.location
  resource_group_name   = azurerm_resource_group.rancher.name
  network_interface_ids = [azurerm_network_interface.rancher-server-nic.id]
  size                  = var.instance_type
  admin_username        = local.node_username

  # custom_data = base64encode(
  #   templatefile(
  #     join("/", [path.module, "files/userdata_quickstart_node.template"]),
  #     {
  #       docker_version   = var.docker_version
  #       username         = local.node_username
  #       register_command = module.rancher_common.custom_cluster_command
  #     }
  #   )
  # )

  license_type = "SLES_BYOS"
  source_image_reference {
    publisher = "SUSE"
    offer     = "sles-15-sp3"
    sku       = "gen1"
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.node_username
    public_key = tls_private_key.global_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip_address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

# ssh command file for Rancher Server VM
resource "local_file" "ssh_to_rancher_server" {
  filename        = "${path.module}/ssh_rancher_server.sh"
  content         = join(" ", ["ssh", "-i id_rsa", "-o StrictHostKeyChecking=no", "${local.node_username}@${azurerm_linux_virtual_machine.rancher_server.public_ip_address}"])
  file_permission = "0755"
}


# Rancher bootstrap password
resource "random_password" "rancher_server_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Rancher resources
module "rancher_server" {
  source = "../../../terraform-modules/rancher"

  node_public_ip      = azurerm_linux_virtual_machine.rancher_server.public_ip_address
  node_internal_ip    = azurerm_linux_virtual_machine.rancher_server.private_ip_address
  node_username       = local.node_username
  ssh_private_key_pem = tls_private_key.global_key.private_key_pem

  rancher_server_dns                = join(".", ["rancher", azurerm_linux_virtual_machine.rancher_server.public_ip_address, "sslip.io"])
  rancher_server_bootstrap_password = random_password.rancher_server_password.result

  windows_prefered_cluster = var.add_windows_node
}
