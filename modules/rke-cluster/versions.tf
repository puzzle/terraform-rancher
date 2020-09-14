terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.1.1"
    }
  }
  required_version = ">= 0.13"
}