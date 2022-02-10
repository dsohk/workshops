# Install longhorn helm chart
resource "helm_release" "longhorn" {
  provider         = longhorn-helm
  repository       = "https://charts.longhorn.io"
  name             = "longhorn"
  chart            = "longhorn"
  version          = "v${var.longhorn_version}"
  namespace        = "longhorn-system"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  verify           = false

  set {
    name  = "persistence.defaultClassReplicaCount"
    value = var.persistence_default_class_replica_count
  }
}

# Wait for 30 seconds till longhorn is fully initialized
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [helm_release.longhorn]
  create_duration = "30s"
}


