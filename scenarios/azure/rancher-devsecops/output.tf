output "rancher_server_url" {
  value = module.rancher_server.rancher_url
}

output "rancher_server_user" {
  value = "admin"
}

output "rancher_server_password" {
  value     = random_password.rancher_server_password.result
  sensitive = true
}

output "jenkins_url" {
  value = module.jenkins.jenkins_url
}

output "jenkins_user" {
  value = module.jenkins.jenkins_user
}

output "jenkins_password" {
  sensitive = true
  value     = module.jenkins.jenkins_password
}


output "neuvector_webui_url" {
  value = module.neuvector.neuvector_webui_url
}

output "neuvector_user" {
  value = module.neuvector.neuvector_user
}

output "neuvector_password" {
  value = module.neuvector.neuvector_password
}

output "harbor_url" {
  value = module.harbor.harbor_url
}

output "harbor_user" {
  value = module.harbor.harbor_user
}

output "harbor_password" {
  sensitive = true
  value     = module.harbor.harbor_password
}