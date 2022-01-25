output "custom_cluster_command" {
  value       = rancher2_cluster_v2.rke2_cluster.cluster_registration_token.0.insecure_node_command
  description = "Linux command ufor adding node to RKE2 cluster"
}

