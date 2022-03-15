terraform {
  required_providers {
    neuvector-helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
  required_version = ">= 1.1.3"
}
