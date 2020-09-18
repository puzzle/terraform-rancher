variable "rancher2_api_url" {
  description   = "Rancher API URL (with protocol)"
  type          = string
  default       = "https://172.20.20.254.xip.puzzle.ch"
}

variable "rancher2_access_key" {
  description   = "Rancher API access key (ensure to create one with 'no scope' limitation)"
  type          = string
  default       = "abc"
}

variable "rancher2_secret_key" {
  description   = "Rancher API secret key (ensure to create one with 'no scope' limitation)"
  type          = string
  default       = "123"
}

variable "custom_kubernetes_version" {
  description   = "Kubernetes version of the custom cluster"
  type          = string
  default       = "v1.18.8-rancher1-1"
}
