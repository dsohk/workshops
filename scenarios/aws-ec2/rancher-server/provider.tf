provider "aws" {
  profile = "default"
  region  = "ap-south-1"
}

# provider "aws" {
#   access_key = var.aws_access_key
#   secret_key = var.aws_secret_key
#   region     = var.aws_region
# }

provider "tls" {
}
