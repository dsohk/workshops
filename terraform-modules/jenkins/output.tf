output "jenkins_url" {
  value = format("https://%s", var.jenkins_ingress_host)
}

output "jenkins_user" {
  value = "admin"
}

output "jenkins_password" {
  sensitive = true
  value     = random_password.jenkins_admin_password.result
}