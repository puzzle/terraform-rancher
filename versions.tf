terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.1.1"
    }
    rancher2 = {
      source = "rancher/rancher2"
      version = "1.10.2"
    }
    time = {
      source = "hashicorp/time"
      version = "0.5.0"
    }
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
    local = {
      source = "hashicorp/local"
      version = "1.4.0"
    }
  }
  required_version = ">= 0.13"
}