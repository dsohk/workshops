# Create downstream RKE2 cluster
resource "rancher2_cluster_v2" "rke2_cluster" {
  provider                                 = rancher2.admin
  name                                     = var.cluster_name
  kubernetes_version                       = "v1.21.4+rke2r2"
  enable_network_policy                    = false
  default_cluster_role_for_project_members = "user"
}
