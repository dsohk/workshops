
# Resource group containing all resources
resource "azurerm_resource_group" "kvm" {
  name     = var.resource_group_name
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
resource "azurerm_virtual_network" "kvm" {
  name                = "kvm-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.kvm.location
  resource_group_name = azurerm_resource_group.kvm.name
}

# Azure internal subnet for quickstart resources
resource "azurerm_subnet" "kvm-subnet" {
  name                 = "kvm-subnet"
  resource_group_name  = azurerm_resource_group.kvm.name
  virtual_network_name = azurerm_virtual_network.kvm.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Public IP of Rancher server
resource "azurerm_public_ip" "kvm-server-pip" {
  name                = "kvm-server-pip"
  location            = azurerm_resource_group.kvm.location
  resource_group_name = azurerm_resource_group.kvm.name
  allocation_method   = "Static"
}

# Azure network interface for rancher server
resource "azurerm_network_interface" "kvm-server-nic" {
  name                = "kvm-server-nic"
  location            = azurerm_resource_group.kvm.location
  resource_group_name = azurerm_resource_group.kvm.name

  ip_configuration {
    name                          = "kvm_server_ip_config"
    subnet_id                     = azurerm_subnet.kvm-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.kvm-server-pip.id
  }

}

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename          = "${local.base_path}/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${local.base_path}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# Cloudinit for kvm-server
data "template_cloudinit_config" "kvm-server-initscript" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      join("/", [path.module, "files/kvm-server-cloudinit.sh"]),
      {
        scc_url       = var.scc_url
        scc_reg_email = var.scc_reg_email
        scc_reg_code  = var.scc_reg_code
      }
    )    
  }
}


# Azure linux virtual machine for creating a single node RKE cluster and installing the Rancher Server
resource "azurerm_linux_virtual_machine" "kvm_server" {
  name                  = "kvm-server"
  computer_name         = "kvm-server" // ensure computer_name meets 15 character limit
  location              = azurerm_resource_group.kvm.location
  resource_group_name   = azurerm_resource_group.kvm.name
  network_interface_ids = [azurerm_network_interface.kvm-server-nic.id]
  size                  = var.instance_type # "Standard_D4ds_v4" (must support nested virtualization and premium disk)
  admin_username        = local.node_username
  custom_data           = data.template_cloudinit_config.kvm-server-initscript.rendered

  # Azure PowerShell Cmd: 
  # > $location = "Central India"
  # > $publisher = "SUSE"
  # > Get-AzVMImageOffer -Location $location -PublisherName $publisher | Select Offer
  license_type = "SLES_BYOS"
  source_image_reference {
    publisher = "SUSE"
    offer     = "sles-15-sp4-byos"
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

# ssh command file for KVM Server VM
resource "local_file" "ssh_to_kvm_server" {
  filename        = "${local.base_path}/ssh_kvm_server.sh"
  content         = join(" ", ["ssh", "-i id_rsa", "-o StrictHostKeyChecking=no", "${local.node_username}@${azurerm_linux_virtual_machine.kvm_server.public_ip_address}"])
  file_permission = "0755"
}

