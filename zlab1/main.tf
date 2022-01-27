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
resource "azurerm_resource_group" "rancher" {
  name     = "${var.prefix}-${var.resource_group_name}"
  location = var.azure_location

  tags = {
    Owner = var.tag_owner
  }
}

# Azure virtual network space for the resource group
resource "azurerm_virtual_network" "rancher" {
  name                = "${var.prefix}-rancher-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rancher.location
  resource_group_name = azurerm_resource_group.rancher.name

  tags = {
    Owner = var.tag_owner
  }
}

# Azure subnet for rancher server
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
  allocation_method   = "Dynamic"

  tags = {
    Owner = var.tag_owner
  }
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

  tags = {
    Owner = var.tag_owner
  }
}

# Azure linux virtual machine for creating a single node RKE cluster and installing the Rancher Server
resource "azurerm_linux_virtual_machine" "rancher_server" {
  name                  = "${var.prefix}-rancher-server"
  computer_name         = "rancher-server" // ensure computer_name meets 15 character limit
  location              = azurerm_resource_group.rancher.location
  resource_group_name   = azurerm_resource_group.rancher.name
  network_interface_ids = [azurerm_network_interface.rancher-server-nic.id]
  size                  = var.rancher_server_vm_size
  admin_username        = local.node_username

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

  tags = {
    Owner = var.tag_owner
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
  source = "../rancher"

  node_public_ip      = azurerm_linux_virtual_machine.rancher_server.public_ip_address
  node_internal_ip    = azurerm_linux_virtual_machine.rancher_server.private_ip_address
  node_username       = local.node_username
  ssh_private_key_pem = tls_private_key.global_key.private_key_pem

  cert_manager_version              = var.cert_manager_version
  rancher_version                   = var.rancher_version
  rancher_server_dns                = join(".", ["rancher", azurerm_linux_virtual_machine.rancher_server.public_ip_address, "sslip.io"])
  rancher_server_bootstrap_password = random_password.rancher_server_password.result

  windows_prefered_cluster = var.add_windows_node
}

# ----------------------------------------------------------------
# Deploy Keycloak Server on RKE2 in Rancher Server
# ----------------------------------------------------------------

# Keycloak admin password
resource "random_password" "keycloak_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# deploy keycloak on Rancher RKE2 cluster
resource "helm_release" "keycloak" {
  depends_on = [
    module.rancher_server,
  ]

  repository       = "https://codecentric.github.io/helm-charts"
  name             = "keycloak"
  chart            = "keycloak"
  version          = var.keycloak_chart_version
  namespace        = "keycloak"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true

  values = [
    templatefile(
       join("/", [path.module, "files/keycloak-helm-values.yaml"]),
       {
         keycloak_admin_password = random_password.keycloak_admin_password.result,
         keycloak_fqdn = join(".", ["keycloak", "${azurerm_linux_virtual_machine.rancher_server.public_ip_address}", "sslip.io"])
       }
    )    
  ]

}

# # ----------------------------------------------------------------
# # Create RKE2 downstream cluster
# # ----------------------------------------------------------------


# # Azure subnet for RKE2 clusters
# resource "azurerm_subnet" "rke2-subnet" {
#   name                 = "rke2-subnet"
#   resource_group_name  = azurerm_resource_group.rancher.name
#   virtual_network_name = azurerm_virtual_network.rancher.name
#   address_prefixes     = ["10.0.1.0/24"]
# }

# # ----------------------------------------------------------------
# # Create downstream RKE2 cluster in Rancher UI
# # ----------------------------------------------------------------

# resource "rancher2_cluster_v2" "rke2_clusters" {
#   count                                    = var.no_of_downstream_clusters
#   provider                                 = rancher2.admin
#   name                                     = format("rke2-cluster%d", count.index + 1)
#   kubernetes_version                       = "v1.21.4+rke2r2"
#   enable_network_policy                    = false
#   default_cluster_role_for_project_members = "user"
# }


# # Public IP of Rancher server
# resource "azurerm_public_ip" "rke2-nodes-pip" {
#   count               = var.no_of_downstream_clusters
#   name                = format("rke2-node%d-pip", count.index + 1)
#   location            = azurerm_resource_group.rancher.location
#   resource_group_name = azurerm_resource_group.rancher.name
#   allocation_method   = "Dynamic"

#   tags = {
#     Owner = var.tag_owner
#   }

# }

# # Azure network interface for rancher server
# resource "azurerm_network_interface" "rke2-nodes-nic" {
#   count               = var.no_of_downstream_clusters
#   name                = format("rke2-node%d-nic", count.index + 1)
#   location            = azurerm_resource_group.rancher.location
#   resource_group_name = azurerm_resource_group.rancher.name

#   ip_configuration {
#     name                          = format("rke2-node%d_ip_config", count.index + 1)
#     subnet_id                     = azurerm_subnet.rke2-subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.rke2-nodes-pip[count.index].id
#   }

#   tags = {
#     Owner = var.tag_owner
#   }
# }

# # Azure linux virtual machine for RKE2 node
# resource "azurerm_linux_virtual_machine" "rke2_node" {
#   count                 = var.no_of_downstream_clusters
#   name                  = format("${var.prefix}-rke2-node%d", count.index + 1)
#   computer_name         = format("rke2-node%d", count.index + 1) // ensure computer_name meets 15 character limit
#   location              = azurerm_resource_group.rancher.location
#   resource_group_name   = azurerm_resource_group.rancher.name
#   network_interface_ids = [azurerm_network_interface.rke2-nodes-nic[count.index].id]
#   size                  = var.rke2_node_vm_size
#   admin_username        = local.node_username

#   # custom_data = base64encode(
#   #   templatefile(
#   #     join("/", [path.module, "files/rke2_node.template"]),
#   #     {
#   #       register_command = rancher2_cluster_v2.rke2_clusters[count.index].cluster_registration_token.0.insecure_node_command
#   #     }
#   #   )
#   # )

#   license_type = "SLES_BYOS"
#   source_image_reference {
#     publisher = "SUSE"
#     offer     = "sles-15-sp3"
#     sku       = "gen1"
#     version   = "latest"
#   }

#   admin_ssh_key {
#     username   = local.node_username
#     public_key = tls_private_key.global_key.public_key_openssh
#   }

#   os_disk {
#     caching              = "ReadWrite"
#     storage_account_type = "Premium_LRS"
#   }

#   tags = {
#     Owner = var.tag_owner
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Waiting for cloud-init to complete...'",
#       "cloud-init status --wait > /dev/null",
#       "echo 'Completed cloud-init!'",
#       "zypper in -q -y jq",
#       "export PUBLIC_IP=`curl -s -H Metadata:true --noproxy '*' 'http://169.254.169.254/metadata/instance/network?api-version=2017-08-01' | jq -r '.interface[0].ipv4.ipAddress[].publicIpAddress'`",
#       "export PRIVATE_IP=`curl -s -H Metadata:true --noproxy '*' 'http://169.254.169.254/metadata/instance/network?api-version=2017-08-01' | jq -r '.interface[0].ipv4.ipAddress[].privateIpAddress'`",
#       format("%s --address $PUBLIC_IP --internal-address $PRIVATE_IP --etcd --controlplane --worker", rancher2_cluster_v2.rke2_clusters[count.index].cluster_registration_token.0.insecure_node_command)
#     ]

#     connection {
#       type        = "ssh"
#       host        = self.public_ip_address
#       user        = local.node_username
#       private_key = tls_private_key.global_key.private_key_pem
#     }
#   }
# }

# # ssh command file for RKE2 nodes VM
# resource "local_file" "ssh_to_rke2_clusters" {
#   count = var.no_of_downstream_clusters
#   filename        = format("${path.module}/ssh_rke2-cluster%d.sh", count.index + 1)
#   content         = join(" ", ["ssh", "-i id_rsa", "-o StrictHostKeyChecking=no", "${local.node_username}@${azurerm_linux_virtual_machine.rke2_node[count.index].public_ip_address}"])
#   file_permission = "0755"
# }

