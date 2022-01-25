# AWS infrastructure resources

## SSH Key for all EC2 instances on AWS

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

resource "aws_key_pair" "ec2_key_pair" {
  key_name_prefix = "${var.prefix}-rancher-"
  public_key      = tls_private_key.global_key.public_key_openssh
  tags = {
    Name  = "${var.prefix}-rancher"
    Owner = var.tag_owner
  }
}

## Security group for Rancher Server

variable "rancher_server_sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "SSH"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "HTTPS - Rancher Server"
    },
    {
      from_port   = 6443
      to_port     = 6443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "RKE2 API Server"
    },
  ]
}

resource "aws_security_group" "rancher_server_sg" {
  name        = "${var.prefix}-rancher-sg"
  description = "Rancher Server Security Group"

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = var.tag_owner
  }

}

resource "aws_security_group_rule" "rancher_server_ingress_rules" {
  count = length(var.rancher_server_sg_ingress_rules)

  type              = "ingress"
  from_port         = var.rancher_server_sg_ingress_rules[count.index].from_port
  to_port           = var.rancher_server_sg_ingress_rules[count.index].to_port
  protocol          = var.rancher_server_sg_ingress_rules[count.index].protocol
  cidr_blocks       = [var.rancher_server_sg_ingress_rules[count.index].cidr_block]
  description       = var.rancher_server_sg_ingress_rules[count.index].description
  security_group_id = aws_security_group.rancher_server_sg.id
}

# Single-Node Rancher Server VM
resource "aws_instance" "rancher_server" {
  ami           = data.aws_ami.sles_x86.id
  instance_type = var.linux_instance_type

  key_name        = aws_key_pair.ec2_key_pair.key_name
  security_groups = [aws_security_group.rancher_server_sg.name]

  root_block_device {
    volume_size = 20
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = {
    Name  = "${var.prefix}-rancher-server"
    Owner = var.tag_owner
  }
}

# ssh command file for Rancher Server VM
resource "local_file" "ssh_to_rancher_server" {
  filename          = "${path.module}/ssh_rancher_server.sh"
  content  = join(" ", ["ssh", "-i id_rsa", "-o StrictHostKeyChecking=no", "${local.node_username}@${aws_instance.rancher_server.public_ip}"])
  file_permission   = "0755"
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

  node_public_ip      = aws_instance.rancher_server.public_ip
  node_internal_ip    = aws_instance.rancher_server.private_ip
  node_username       = local.node_username
  ssh_private_key_pem = tls_private_key.global_key.private_key_pem

  cert_manager_version              = var.cert_manager_version
  rancher_version                   = var.rancher_version
  rancher_server_dns                = join(".", ["rancher", aws_instance.rancher_server.public_ip, "sslip.io"])
  rancher_server_bootstrap_password = random_password.rancher_server_password.result

  windows_prefered_cluster = var.add_windows_node
}

