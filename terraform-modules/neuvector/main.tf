# Install neuvector helm chart
resource "helm_release" "neuvector" {
  provider         = neuvector-helm
  repository       = "https://neuvector.github.io/neuvector-helm"
  name             = "neuvector"
  chart            = "neuvector/core"
  version          = "${neuvector_helm_chart_version}"
  namespace        = "neuvector"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  verify           = false

  set {
    name  = "tag"
    value = var.neuvector_version
  }

  set {
    name  = "registry"
    value = "docker.io"
  }

  set {
    name  = "controller.image.repository"
    value = "neuvector/controller.preview"
  }  

  set {
    name  = "enforcer.image.repository"
    value = "neuvector/enforcer.preview"
  }    

  set {
    name  = "manager.image.repository"
    value = "neuvector/manager.preview"
  }  

  set {
    name  = "cve.scanner.image.repository"
    value = "neuvector/scanner.preview"
  }  

}

# Wait for 30 seconds till longhorn is fully initialized
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [helm_release.neuvector]
  create_duration = "30s"
}

