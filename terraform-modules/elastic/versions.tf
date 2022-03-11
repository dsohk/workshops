terraform {
  required_providers {
    elastic-helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    elastic-kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.13.1"
    }
    elastic-kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
  required_version = ">= 1.1.3"
}
