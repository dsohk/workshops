# Azure Infrastructure Resources

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

# Resource group containing all resources
resource "azurerm_resource_group" "rke2-cluster" {
  name     = "${var.prefix}-${var.resource_group_name}"
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
resource "azurerm_virtual_network" "rke2-cluster" {
  name                = "${var.prefix}-rke2-cluster-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rke2-cluster.location
  resource_group_name = azurerm_resource_group.rke2-cluster.name
}

# ----------------------------------------------------------------
# Azure Load Balancer
# ----------------------------------------------------------------

# Azure Load Balancer - Public IP
resource "azurerm_public_ip" "rke2-lb-pip" {
  name                = "rke2-lb-pip"
  location            = azurerm_resource_group.rke2-cluster.location
  resource_group_name = azurerm_resource_group.rke2-cluster.name
  allocation_method   = "Static"
}

# Define Azure Load Balancer with frontend IP configuration
resource "azurerm_lb" "rke2-lb" {
  name                = "rke2-lb"
  location            = azurerm_resource_group.rke2-cluster.location
  resource_group_name = azurerm_resource_group.rke2-cluster.name

  frontend_ip_configuration {
    name                 = "rke2-lb-frontend_ip_configuration"
    public_ip_address_id = azurerm_public_ip.rke2-lb-pip.id
  }
}

# Define backend pool for LB
resource "azurerm_lb_backend_address_pool" "rke2-lb" {
  loadbalancer_id = azurerm_lb.rke2-lb.id
  name            = "rke2-lb-backend_address_pool"
}

# Create an LB probe on port 80
resource "azurerm_lb_probe" "rke2-lb" {
  resource_group_name = azurerm_resource_group.rke2-cluster.name
  loadbalancer_id     = azurerm_lb.rke2-lb.id
  name                = "rke2-lb-probe-tcp80"
  port                = 80
}

# Create an LB rule for port 6443 (KubeAPI)
resource "azurerm_lb_rule" "rke2-lb-rule-6443" {
  resource_group_name            = azurerm_resource_group.rke2-cluster.name
  loadbalancer_id                = azurerm_lb.rke2-lb.id
  name                           = "rke2-lb-rule-6443"
  protocol                       = "Tcp"
  frontend_port                  = 6443
  backend_port                   = 6443
  frontend_ip_configuration_name = "rke2-lb-frontend_ip_configuration"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.rke2-lb.id]
}

# Create an LB rule for port 443 (https)
resource "azurerm_lb_rule" "rke2-lb-rule-443" {
  resource_group_name            = azurerm_resource_group.rke2-cluster.name
  loadbalancer_id                = azurerm_lb.rke2-lb.id
  name                           = "rke2-lb-rule-443"
  protocol                       = "Tcp"
  frontend_port                  = 443
  backend_port                   = 443
  frontend_ip_configuration_name = "rke2-lb-frontend_ip_configuration"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.rke2-lb.id]
}


# --------------------------------
# RKE2 cluster on Azure
# --------------------------------

# Azure subnet for rke2-cluster
resource "azurerm_subnet" "rke2-cluster-subnet" {
  name                 = "rke2-cluster-subnet"
  resource_group_name  = azurerm_resource_group.rke2-cluster.name
  virtual_network_name = azurerm_virtual_network.rke2-cluster.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Public IP of RKE2 nodes
resource "azurerm_public_ip" "rke2-nodes-pip" {
  count               = var.rke2-cluster-size
  name                = format("rke2-node%d-pip", count.index + 1)
  location            = azurerm_resource_group.rke2-cluster.location
  resource_group_name = azurerm_resource_group.rke2-cluster.name
  allocation_method   = "Dynamic"
}

# RKE2 node network security group
resource "azurerm_network_security_group" "rke2-node-nsg" {
  name                = "rke2-node-nsg"
  location            = azurerm_resource_group.rke2-cluster.location
  resource_group_name = azurerm_resource_group.rke2-cluster.name
}

# RKE2 node network security group rules
resource "azurerm_network_security_rule" "rke2-node-nsg-rule-allowall" {
  name                        = "rke2-node-nsg-rule-allowall"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.rke2-cluster.name
  network_security_group_name = azurerm_network_security_group.rke2-node-nsg.name
}

# Azure network interface for RKE2 Node
resource "azurerm_network_interface" "rke2-nodes-nic" {
  count               = var.rke2-cluster-size
  name                = format("rke2-node%d-nic", count.index + 1)
  location            = azurerm_resource_group.rke2-cluster.location
  resource_group_name = azurerm_resource_group.rke2-cluster.name

  ip_configuration {
    name                          = format("rke2-node%d_ip_config", count.index + 1)
    subnet_id                     = azurerm_subnet.rke2-cluster-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rke2-nodes-pip[count.index].id
  }
}

# Associate network interface with RKE2 Network Security Group
resource "azurerm_network_interface_security_group_association" "rke2-nodes-nic-nsg" {
  count                     = var.rke2-cluster-size
  network_interface_id      = azurerm_network_interface.rke2-nodes-nic[count.index].id
  network_security_group_id = azurerm_network_security_group.rke2-node-nsg.id
}

# Associate network interface with LB backend pool
resource "azurerm_network_interface_backend_address_pool_association" "rke2-nodes-nic-lb-backend-pool" {
  count                   = var.rke2-cluster-size
  network_interface_id    = azurerm_network_interface.rke2-nodes-nic[count.index].id
  ip_configuration_name   = format("rke2-node%d_ip_config", count.index + 1)
  backend_address_pool_id = azurerm_lb_backend_address_pool.rke2-lb.id
}

# Availability Set for RKE2 VMs
resource "azurerm_availability_set" "rke2-nodes-as" {
  name                         = "rke2-nodes-as"
  location                     = azurerm_resource_group.rke2-cluster.location
  resource_group_name          = azurerm_resource_group.rke2-cluster.name
  platform_update_domain_count = 3
  platform_fault_domain_count  = 3
}

# Azure linux virtual machine for RKE2 nodes
resource "azurerm_linux_virtual_machine" "rke2_node" {
  count                 = var.rke2-cluster-size
  name                  = format("${var.prefix}-rke2-node%d", count.index + 1)
  computer_name         = format("rke2-node%d", count.index + 1) // ensure computer_name meets 15 character limit
  location              = azurerm_resource_group.rke2-cluster.location
  resource_group_name   = azurerm_resource_group.rke2-cluster.name
  network_interface_ids = [azurerm_network_interface.rke2-nodes-nic[count.index].id]
  size                  = var.rke2_node_vm_size
  admin_username        = local.node_username
  availability_set_id   = azurerm_availability_set.rke2-nodes-as.id

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
      format("sleep %d", count.index * 60), # wait 60s between nodes to avoid join node simulatenously which is error prone.
      templatefile(join("/", [path.module, "files/install_rke2.sh"]), {
        first_instance              = (count.index == 0) ? "yes" : "no",
        rke2_first_node_public_ip   = azurerm_linux_virtual_machine.rke2_node[0].public_ip_address
        rke2_loadbalancer_public_ip = azurerm_public_ip.rke2-lb-pip.ip_address
      })
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip_address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

# ssh command file for RKE2 nodes VM
resource "local_file" "ssh_to_rke2_nodes" {
  count           = var.rke2-cluster-size
  filename        = format("${path.module}/ssh_rke2-node%d.sh", count.index + 1)
  content         = join(" ", ["ssh", "-i id_rsa", "-o StrictHostKeyChecking=no", "${local.node_username}@${azurerm_linux_virtual_machine.rke2_node[count.index].public_ip_address}"])
  file_permission = "0755"
}

resource "ssh_resource" "retrieve_config" {
  depends_on = [azurerm_linux_virtual_machine.rke2_node]
  host       = azurerm_linux_virtual_machine.rke2_node[0].public_ip_address
  commands = [
    "sudo sed \"s/127.0.0.1/${azurerm_public_ip.rke2-lb-pip.ip_address}/g\" /etc/rancher/rke2/rke2.yaml"
  ]
  user        = local.node_username
  private_key = tls_private_key.global_key.private_key_pem
}

# Save kubeconfig file for interacting with the RKE cluster on your local machine
resource "local_file" "kube_config_server_yaml" {
  depends_on = [azurerm_linux_virtual_machine.rke2_node]
  filename   = format("%s/%s", path.root, "kube_config_server.yaml")
  content    = ssh_resource.retrieve_config.result
}