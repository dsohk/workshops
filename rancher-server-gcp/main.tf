# GCP infrastructure resources

## SSH Key for all GCP instances

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

# GCP Public Compute Address for rancher server node
resource "google_compute_address" "rancher_server_address" {
  name = "${var.prefix}-rancher-server-ipv4"
}

# Firewall Rule to allow all traffic
resource "google_compute_firewall" "rancher_server_fw" {
  name    = "${var.prefix}-rancher-server-fw"
  network = "default"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "6443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# GCP Compute Instance for creating a single node RKE2 cluster and installing the Rancher server
resource "google_compute_instance" "rancher_server" {
  depends_on = [
    google_compute_firewall.rancher_server_fw,
  ]

  name         = "${var.prefix}-rancher-server"
  machine_type = var.machine_type
  zone         = var.gcp_zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.sles.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.rancher_server_address.address
    }
  }

  metadata = {
    ssh-keys = "${local.node_username}:${tls_private_key.global_key.public_key_openssh}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'SSH connection worked'",
    ]

    connection {
      type        = "ssh"
      host        = self.network_interface.0.access_config.0.nat_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}


# ssh command file for Rancher Server VM
resource "local_file" "ssh_to_rancher_server" {
  filename        = "${path.module}/ssh_rancher_server.sh"
  content         = join(" ", ["ssh", "-i id_rsa", "-o StrictHostKeyChecking=no", "${local.node_username}@${google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip}"])
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

  node_public_ip      = google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip
  node_internal_ip    = google_compute_instance.rancher_server.network_interface.0.network_ip
  node_username       = local.node_username
  ssh_private_key_pem = tls_private_key.global_key.private_key_pem

  cert_manager_version              = var.cert_manager_version
  rancher_version                   = var.rancher_version
  rancher_server_dns                = join(".", ["rancher", google_compute_instance.rancher_server.network_interface.0.access_config.0.nat_ip, "sslip.io"])
  rancher_server_bootstrap_password = random_password.rancher_server_password.result

  windows_prefered_cluster = var.add_windows_node
}

