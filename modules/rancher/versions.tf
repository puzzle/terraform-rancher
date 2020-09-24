terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "1.3.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.7.1"
    }
    null = {
      source = "hashicorp/null"
      version = "2.1.2"
    }
  }
  required_version = ">= 0.13"
}