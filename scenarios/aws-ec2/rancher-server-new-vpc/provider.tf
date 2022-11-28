provider "aws" {
  # profile = "default"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

provider "tls" {
}

provider "rancher2" {
  alias = "admin"

  api_url  = module.rancher_server.rancher_url
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  token_key = module.rancher_server.rancher_admin_token
}