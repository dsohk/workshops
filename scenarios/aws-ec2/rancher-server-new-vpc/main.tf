# AWS infrastructure resources

## SSH Key for all EC2 instances on AWS

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename        = "${path.module}/id_rsa"
  content         = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
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

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "rancher-vpc"
  cidr = "10.0.0.0/16"

  # setup multiple AZ with public subnets only
  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  # private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false

  tags = {
    Environment = "demo"
    Owner       = var.tag_owner
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
  vpc_id      = module.vpc.vpc_id

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

resource "aws_network_interface" "rancher_server" {
  subnet_id       = module.vpc.public_subnets[0]
  private_ips     = ["10.0.101.10"]
  security_groups = [aws_security_group.rancher_server_sg.id]

  tags = {
    Name = "rancher_server_nic"
  }
}

resource "aws_eip" "rancher_server_eip" {
  instance                  = aws_instance.rancher_server.id
  associate_with_private_ip = "10.0.101.10"
  vpc                       = true
  depends_on                = [module.vpc.public_internet_gateway_route_id]
}

# Single-Node Rancher Server VM
resource "aws_instance" "rancher_server" {
  ami           = data.aws_ami.sles_x86.id
  instance_type = var.linux_master_instance_type
  key_name      = aws_key_pair.ec2_key_pair.key_name

  root_block_device {
    volume_size = 30
  }

  network_interface {
    network_interface_id = aws_network_interface.rancher_server.id
    device_index         = 0
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
  filename        = "${path.module}/ssh_rancher_server.sh"
  content         = join(" ", ["ssh", "-i id_rsa", "-o StrictHostKeyChecking=no", "${local.node_username}@${aws_eip.rancher_server_eip.public_ip}"])
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

  node_public_ip      = aws_eip.rancher_server_eip.public_ip
  node_internal_ip    = aws_instance.rancher_server.private_ip
  node_username       = local.node_username
  ssh_private_key_pem = tls_private_key.global_key.private_key_pem

  cert_manager_version              = var.cert_manager_version
  rancher_version                   = var.rancher_version
  rancher_server_dns                = join(".", ["rancher", aws_eip.rancher_server_eip.public_ip, "sslip.io"])
  rancher_server_bootstrap_password = random_password.rancher_server_password.result

  windows_prefered_cluster = var.add_windows_node
}

# Create a new rancher2 Cloud Credential
resource "rancher2_cloud_credential" "my_aws" {
  provider    = rancher2.admin
  name        = "my_aws"
  description = "Rancher on AWS Demo"
  amazonec2_credential_config {
    access_key = var.aws_access_key
    secret_key = var.aws_secret_key
  }
}

# setup IAM Instance Profile for RKE2 cluster
module "aws_iam_rke" {
  source         = "../../../terraform-modules/aws_iam_rke"
  aws_access_key = var.aws_access_key
  aws_secret_key = var.aws_secret_key
  aws_region     = var.aws_region
}

resource "aws_security_group" "rke_node_sg" {
  name        = "${var.prefix}-rke_node-sg"
  description = "RKE(2) Node Security Group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

# locals {
#   azs = ["a", "b", "c"]
# }

<<<<<<< Updated upstream
resource "rancher2_machine_config_v2" "rke2-master" {
  provider      = rancher2.admin
  count         = length(module.vpc.public_subnets)
  generate_name = "rke2-master"
  amazonec2_config {
    ami                  = data.aws_ami.sles_x86.id
    region               = var.aws_region
    security_group       = [aws_security_group.rke_node_sg.name]
    subnet_id            = module.vpc.public_subnets[count.index]
    private_address_only = false
    vpc_id               = module.vpc.vpc_id
    zone                 = local.azs[count.index]
    iam_instance_profile = module.aws_iam_rke.rke_master_iam_instance_profile
    instance_type        = var.linux_master_instance_type
    keypair_name         = aws_key_pair.ec2_key_pair.key_name
    ssh_key_contents     = tls_private_key.global_key.public_key_openssh
    ssh_user             = local.node_username
    root_size            = 30 # 30GB root disk
  }
}

resource "rancher2_machine_config_v2" "rke2-worker" {
  provider      = rancher2.admin
  count         = length(module.vpc.public_subnets)
  generate_name = "rke2-worker"
  amazonec2_config {
    ami                  = data.aws_ami.sles_x86.id
    region               = var.aws_region
    security_group       = [aws_security_group.rke_node_sg.name]
    subnet_id            = module.vpc.public_subnets[count.index]
    private_address_only = false
    vpc_id               = module.vpc.vpc_id
    zone                 = local.azs[count.index]
    iam_instance_profile = module.aws_iam_rke.rke_worker_iam_instance_profile
    instance_type        = var.linux_worker_instance_type
    keypair_name         = aws_key_pair.ec2_key_pair.key_name
    ssh_key_contents     = tls_private_key.global_key.public_key_openssh
    ssh_user             = local.node_username
    root_size            = 30 # 30GB root disk
  }
}
=======
# resource "rancher2_machine_config_v2" "rke2-master" {
#   provider      = rancher2.admin
#   count         = length(module.vpc.private_subnets)
#   generate_name = "rke2-master"
#   amazonec2_config {
#     ami                  = data.aws_ami.sles_x86.id
#     region               = var.aws_region
#     security_group       = [aws_security_group.rke_node_sg.name]
#     subnet_id            = module.vpc.private_subnets[count.index]
#     private_address_only = true
#     vpc_id               = module.vpc.vpc_id
#     zone                 = local.azs[count.index]
#     iam_instance_profile = module.aws_iam_rke.rke_master_iam_instance_profile
#     instance_type        = var.linux_instance_type
#     keypair_name         = aws_key_pair.ec2_key_pair.key_name
#     ssh_key_contents     = tls_private_key.global_key.public_key_openssh
#     ssh_user             = local.node_username
#     root_size            = 30 # 30GB root disk
#   }
# }

# resource "rancher2_machine_config_v2" "rke2-worker" {
#   provider      = rancher2.admin
#   count         = length(module.vpc.private_subnets)
#   generate_name = "rke2-worker"
#   amazonec2_config {
#     ami                  = data.aws_ami.sles_x86.id
#     region               = var.aws_region
#     security_group       = [aws_security_group.rke_node_sg.name]
#     subnet_id            = module.vpc.private_subnets[count.index]
#     private_address_only = true
#     vpc_id               = module.vpc.vpc_id
#     zone                 = local.azs[count.index]
#     iam_instance_profile = module.aws_iam_rke.rke_worker_iam_instance_profile
#     instance_type        = var.linux_instance_type
#     keypair_name         = aws_key_pair.ec2_key_pair.key_name
#     ssh_key_contents     = tls_private_key.global_key.public_key_openssh
#     ssh_user             = local.node_username
#     root_size            = 30 # 30GB root disk
#   }
# }
>>>>>>> Stashed changes

# locals {
#   rke2_worker_machine_configs = [for config in rancher2_machine_config_v2.rke2-worker :
#     {
#       kind = config.kind
#       name = config.name
#     }
#   ]
# }

# # Create a new rancher v2 amazonec2 RKE2 Cluster v2
# resource "rancher2_cluster_v2" "rke2" {
#   provider                                 = rancher2.admin
#   name                                     = "rke2-on-ec2"
#   kubernetes_version                       = "v1.24.4+rke2r1"
#   enable_network_policy                    = false
#   default_cluster_role_for_project_members = "user"
#   rke_config {
#     machine_pools {
#       name                         = "master"
#       cloud_credential_secret_name = rancher2_cloud_credential.my_aws.id
#       control_plane_role           = true
#       etcd_role                    = true
#       worker_role                  = false
#       quantity                     = 1
#       machine_config {
#         kind = rancher2_machine_config_v2.rke2-master[0].kind
#         name = rancher2_machine_config_v2.rke2-master[0].name
#       }
#     }
#     machine_pools {
#       name                         = "worker-a"
#       cloud_credential_secret_name = rancher2_cloud_credential.my_aws.id
#       control_plane_role           = false
#       etcd_role                    = false
#       worker_role                  = true
#       quantity                     = 1
#       machine_config {
#         kind = rancher2_machine_config_v2.rke2-worker[0].kind
#         name = rancher2_machine_config_v2.rke2-worker[0].name
#       }
#     }
#     machine_pools {
#       name                         = "worker-b"
#       cloud_credential_secret_name = rancher2_cloud_credential.my_aws.id
#       control_plane_role           = false
#       etcd_role                    = false
#       worker_role                  = true
#       quantity                     = 1
#       machine_config {
#         kind = rancher2_machine_config_v2.rke2-worker[1].kind
#         name = rancher2_machine_config_v2.rke2-worker[1].name
#       }
#     }
#     machine_pools {
#       name                         = "worker-c"
#       cloud_credential_secret_name = rancher2_cloud_credential.my_aws.id
#       control_plane_role           = false
#       etcd_role                    = false
#       worker_role                  = true
#       quantity                     = 1
#       machine_config {
#         kind = rancher2_machine_config_v2.rke2-worker[2].kind
#         name = rancher2_machine_config_v2.rke2-worker[2].name
#       }
#     }
#     machine_selector_config {
#       config = {
#         cloud-provider-name = "aws"
#       }
#     }
#   }
# }


# # Creating Amazon EFS File system
# resource "aws_efs_file_system" "rke2_efs" {
#   lifecycle_policy {
#     transition_to_ia = "AFTER_30_DAYS"
#   }
#   tags = {
#     Owner = var.tag_owner
#   }
# }

# # Creating the EFS access point for AWS EFS File system
# resource "aws_efs_access_point" "rke2_efs_ap" {
#   file_system_id = aws_efs_file_system.rke2_efs.id
# }

<<<<<<< Updated upstream
# Creating the AWS EFS System policy to transition files into and out of the file system.
resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.rke2_efs.id
  # The EFS System Policy allows clients to mount, read and perform 
  # write operations on File system 
  # The communication of client and EFS is set using aws:secureTransport Option
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "Policy01",
    "Statement": [
        {
            "Sid": "Statement",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Resource": "${aws_efs_file_system.rke2_efs.arn}",
            "Action": [
                "elasticfilesystem:*"
            ],
            "Condition": {
                "Bool": {
                    "aws:SecureTransport": "false"
                }
            }
        }
    ]
}
POLICY
}
# Creating the AWS EFS Mount point in a specified Subnet 
# AWS EFS Mount point uses File system ID to launch.
resource "aws_efs_mount_target" "rke2_efs_mount" {
  count          = length(module.vpc.public_subnets)
  file_system_id = aws_efs_file_system.rke2_efs.id
  subnet_id      = module.vpc.public_subnets[count.index]
}
=======
# # Creating the AWS EFS System policy to transition files into and out of the file system.
# resource "aws_efs_file_system_policy" "policy" {
#   file_system_id = aws_efs_file_system.rke2_efs.id
#   # The EFS System Policy allows clients to mount, read and perform 
#   # write operations on File system 
#   # The communication of client and EFS is set using aws:secureTransport Option
#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Id": "Policy01",
#     "Statement": [
#         {
#             "Sid": "Statement",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "*"
#             },
#             "Resource": "${aws_efs_file_system.rke2_efs.arn}",
#             "Action": [
#                 "elasticfilesystem:ClientMount",
#                 "elasticfilesystem:ClientRootAccess",
#                 "elasticfilesystem:ClientWrite"
#             ],
#             "Condition": {
#                 "Bool": {
#                     "aws:SecureTransport": "false"
#                 }
#             }
#         }
#     ]
# }
# POLICY
# }
# # Creating the AWS EFS Mount point in a specified Subnet 
# # AWS EFS Mount point uses File system ID to launch.
# resource "aws_efs_mount_target" "rke2_efs_mount" {
#   count          = length(module.vpc.private_subnets)
#   file_system_id = aws_efs_file_system.rke2_efs.id
#   subnet_id      = module.vpc.private_subnets[count.index]
# }
>>>>>>> Stashed changes

# https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html

# helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/

# helm repo update

# helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
#     --namespace kube-system \
#     --set image.repository=602401143452.dkr.ecr.us-east-1.amazonaws.com/eks/aws-efs-csi-driver \
#     --set controller.serviceAccount.create=true \
#     --set controller.serviceAccount.name=efs-csi-controller-sa

# curl -o storageclass.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/examples/kubernetes/dynamic_provisioning/specs/storageclass.yaml
# replace fsid

# curl -o pod.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/examples/kubernetes/dynamic_provisioning/specs/pod.yaml

# kubectl logs efs-csi-controller-c5d76b47f-rvlr8 \
#     -n kube-system \
#     -c csi-provisioner \
#     --tail 10




# MountVolume.SetUp failed for volume "pvc-e38f4afc-cb1e-41c7-b9d5-7c9cf466e4ff" : rpc error: code = Internal desc = Could not mount "fs-05f49f86c36fd4cf3:/" at "/var/lib/kubelet/pods/ca679df5-469b-4b5d-bab2-2d1a2d0b78e1/volumes/kubernetes.io~csi/pvc-e38f4afc-cb1e-41c7-b9d5-7c9cf466e4ff/mount": mount failed: exit status 1 Mounting command: mount Mounting arguments: -t efs -o accesspoint=fsap-08977422a3ce5fdc0,tls fs-05f49f86c36fd4cf3:/ /var/lib/kubelet/pods/ca679df5-469b-4b5d-bab2-2d1a2d0b78e1/volumes/kubernetes.io~csi/pvc-e38f4afc-cb1e-41c7-b9d5-7c9cf466e4ff/mount Output: Failed to resolve "fs-05f49f86c36fd4cf3.efs.us-east-1.amazonaws.com". Cannot connect to file system mount target ip address 10.0.3.95. Connection to the mount target IP address 10.0.3.95 timeout. Please retry in 5 minutes if the mount target is newly created. Otherwise check your VPC and security group configuration to ensure your file system is reachable via TCP port 2049 from your instance. Warning: config file does not have fips_mode_enabled item in section mount.. You should be able to find a new config file in the same folder as current config file /etc/amazon/efs/efs-utils.conf. Consider update the new config file to latest config file. Use the default value [fips_mode_enabled = False].Warning: config file does not have fips_mode_enabled item in section mount.. You should be able to find a new config file in the same folder as current config file /etc/amazon/efs/efs-utils.conf. Consider update the new config file to latest config file. Use the default value [fips_mode_enabled = False].