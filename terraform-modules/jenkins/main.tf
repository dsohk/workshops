# private key algorithm
resource "tls_private_key" "jenkins" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# jenkins private key
resource "local_file" "jenkins_private_key_pem" {
  filename          = "${path.module}/jenkins.pem"
  sensitive_content = tls_private_key.jenkins.private_key_pem
  file_permission   = "0600"
}

# jenkins self-signed cert
resource "tls_self_signed_cert" "jenkins" {
  key_algorithm   = tls_private_key.jenkins.algorithm
  private_key_pem = tls_private_key.jenkins.private_key_pem

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

  dns_names = [var.jenkins_ingress_host, var.notary_ingress_host]

  subject {
    common_name  = var.jenkins_ingress_host
    organization = var.jenkins_ingress_host
  }
}

# jenkins certificate
resource "local_file" "jenkins_crt" {
  filename          = "${path.module}/jenkins.crt"
  sensitive_content = tls_self_signed_cert.jenkins.cert_pem
  file_permission   = "0600"
}

# deploy jenkins on Rancher RKE2 cluster

# create secret for storing jenkins tls in namespace jenkins
resource "kubernetes_namespace" "jenkins" {
  depends_on = [var.jenkins_depends_on]
  metadata {
    name = "jenkins"
  }
}
resource "kubernetes_secret" "jenkins_tls" {
  depends_on = [var.jenkins_depends_on, kubernetes_namespace.jenkins]
  metadata {
    name      = "jenkins-tls"
    namespace = "jenkins"
  }
  type = "tls"
  data = {
    "tls.crt" = tls_self_signed_cert.jenkins.cert_pem
    "tls.key" = tls_private_key.jenkins.private_key_pem
  }
}

# jenkins admin password
resource "random_password" "jenkins_admin_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Install jenkins helm chart
resource "helm_release" "jenkins" {
  repository       = "https://helm.gojenkins.io"
  name             = "jenkins"
  chart            = "jenkins"
  version          = var.jenkins_helm_chart_version
  namespace        = "jenkins"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  verify           = false

  values = [
    templatefile(
      join("/", [path.module, "files/jenkins-helm-values.yaml"]),
      {
        jenkins_admin_password = random_password.jenkins_admin_password.result,
        jenkins_ingress_host   = var.jenkins_ingress_host,
        notary_ingress_host    = var.notary_ingress_host,
        external_url           = format("https://%s", var.jenkins_ingress_host)
      }
    )
  ]

  depends_on = [var.jenkins_depends_on, kubernetes_secret.jenkins_tls]

}

# Wait for 30 seconds till jenkins is fully initialized
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [helm_release.jenkins]
  create_duration = "30s"
}

