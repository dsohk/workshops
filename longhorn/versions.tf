terraform {
  required_providers {
    longhorn-helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
  }
  required_version = ">= 1.1.3"
}
