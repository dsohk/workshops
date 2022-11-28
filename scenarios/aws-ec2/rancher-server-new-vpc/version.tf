terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.24.2"
    }
  }

  required_version = ">= 0.14.9"
}