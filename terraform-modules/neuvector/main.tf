# private key algorithm
resource "tls_private_key" "neuvector" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# neuvector private key
resource "local_file" "neuvector_private_key_pem" {
  filename          = "${path.module}/neuvector.pem"
  sensitive_content = tls_private_key.neuvector.private_key_pem
  file_permission   = "0600"
}

# neuvector self-signed cert
resource "tls_self_signed_cert" "neuvector" {
  key_algorithm   = tls_private_key.neuvector.algorithm
  private_key_pem = tls_private_key.neuvector.private_key_pem

  # Certificate expires after 365 days.
  validity_period_hours = 8760

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = 3

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = [var.ingress_host]

  subject {
    common_name  = var.ingress_host
    organization = var.ingress_host
  }
}

# neuvector certificate
resource "local_file" "neuvector_crt" {
  filename          = "${path.module}/neuvector.crt"
  sensitive_content = tls_self_signed_cert.neuvector.cert_pem
  file_permission   = "0600"
}

# deploy neuvector on Rancher RKE2 cluster

# create secret for storing neuvector tls in namespace neuvector
resource "kubernetes_namespace" "neuvector" {
  depends_on = [var.neuvector_depends_on]
  metadata {
    name = "neuvector"
  }
}
resource "kubernetes_secret" "neuvector_tls" {
  depends_on = [var.neuvector_depends_on, kubernetes_namespace.neuvector]
  metadata {
    name      = "neuvector-tls"
    namespace = "neuvector"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_self_signed_cert.neuvector.cert_pem
    "tls.key" = tls_private_key.neuvector.private_key_pem
  }
}


# Install neuvector helm chart
resource "helm_release" "neuvector" {
  provider         = neuvector-helm
  repository       = "https://neuvector.github.io/neuvector-helm"
  name             = "neuvector"
  chart            = "core"
  version          = var.neuvector_helm_chart_version
  namespace        = "neuvector"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  verify           = false

  values = [
    templatefile(
      join("/", [path.module, "files/neuvector-helm-values.yaml"]),
      {
        neuvector_version = var.neuvector_version,
        ingress_host      = var.ingress_host
      }
    )
  ]

  depends_on = [var.neuvector_depends_on, kubernetes_secret.neuvector_tls]


}

# Wait for 30 seconds till longhorn is fully initialized
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [helm_release.neuvector]
  create_duration = "30s"
}

