# Install nfs-server helm chart
resource "helm_release" "nfs-server-provisioner" {
  provider         = nfs-provisioner-helm
  repository       = "https://kubernetes-sigs.github.io/nfs-ganesha-server-and-external-provisioner/"
  name             = "nfs"
  chart            = "nfs-server-provisioner"
  version          = var.nfs_server_version
  namespace        = "nfs-system"
  create_namespace = true
  wait             = true
  wait_for_jobs    = true
  verify           = false

  set {
    name  = "storageClass.defaultClass"
    value = var.storageclass_defaultclass
  }

  depends_on = [var.nfs_server_depends_on]

}

# Wait for 30 seconds till nfs-server is fully initialized
resource "time_sleep" "wait_30_seconds" {
  depends_on      = [helm_release.nfs-server-provisioner]
  create_duration = "30s"
}


