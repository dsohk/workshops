output "rancher_server_url" {
  value = module.rancher_server.rancher_url
}

output "rancher_server_ip" {
  value = aws_instance.rancher_server.public_ip
}

output "rancher_server_bootstrap_password" {
  value     = random_password.rancher_server_password.result
  sensitive = true
}
