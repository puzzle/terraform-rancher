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
  }
  required_version = ">= 0.13"
}