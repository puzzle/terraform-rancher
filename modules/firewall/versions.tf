terraform {
  required_providers {
    time = {
      source = "hashicorp/time"
      version = "0.5.0"
    }
    null = {
      source = "hashicorp/null"
      version = "2.1.2"
    }
  }
  required_version = ">= 0.13"
}