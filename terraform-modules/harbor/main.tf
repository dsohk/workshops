# private key algorithm
resource "tls_private_key" "harbor" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# harbor private key
resource "local_file" "harbor_private_key_pem" {
  filename          = "${var.harbor_sslcert_path}/harbor.pem"
  sensitive_content = tls_private_key.harbor.private_key_pem
  file_permission   = "0600"
}

# harbor self-signed cert
resource "tls_self_signed_cert" "harbor" {
  key_algorithm   = tls_private_key.harbor.algorithm
  private_key_pem = tls_private_key.harbor.private_key_pem

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

  dns_names = [var.harbor_ingress_host, var.notary_ingress_host]

  subject {
    common_name  = var.harbor_ingress_host
    organization = var.harbor_ingress_host
  }
}

# harbor certificate
resource "local_file" "harbor_crt" {
  filename          = "${var.harbor_sslcert_path}/harbor.crt"
  sensitive_content = tls_self_signed_cert.harbor.cert_pem
  file_permission   = "0600"
}

# deploy harbor on Rancher RKE2 cluster

# create secret for storing harbor tls in namespace harbor
resource "kubernetes_namespace" "harbor" {
  depends_on = [var.harbor_depends_on]
  metadata {
    name = "harbor"
  }
}
resource "kubernetes_secret" "harbor_tls" {
  depends_on = [var.harbor_depends_on, kubernetes_namespace.harbor]
  metadata {
    name      = "harbor-tls"
    namespace = "harbor"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_self_signed_cert.harbor.cert_pem
    "tls.key" = tls_private_key.harbor.private_key_pem
  }
}

# Harbor admin password
resource "random_password" "harbor_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Install harbor helm chart
resource "helm_release" "harbor" {
  repository       = "https://helm.goharbor.io"
  name             = "harbor"
  chart            = "harbor"
  version          = var.harbor_helm_chart_version
  namespace        = "harbor"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  verify           = false

  values = [
    templatefile(
      join("/", [path.module, "files/harbor-helm-values.yaml"]),
      {
        harbor_admin_password = random_password.harbor_admin_password.result,
        harbor_ingress_host   = var.harbor_ingress_host,
        notary_ingress_host   = var.notary_ingress_host,
        external_url          = format("https://%s", var.harbor_ingress_host)
      }
    )
  ]

  depends_on = [var.harbor_depends_on, kubernetes_secret.harbor_tls]

}

# Wait for 30 seconds till harbor is fully initialized
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [helm_release.harbor]
  create_duration = "30s"
}

