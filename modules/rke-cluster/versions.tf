terraform {
  required_providers {
    rke = {
      source = "rancher/rke"
      version = "1.1.1"
    }
    local = {
      source = "hashicorp/local"
      version = "1.4.0"
    }
  }
  required_version = ">= 0.13"
}