###################################################################
# RKE Rancher Control Plane Cluster Configuration
###################################################################

variable "enable_rke_k8s_cluster" {
  description   = "Enable or disable the creation/handling of a RKE K8s cluster"
  type          = bool
  default       = true
}

# Enable or disable the creation/handling of a RKE K8s cluster
enable_rke_k8s_cluster = false

variable "rke_nodes"  {
  description   = "RKE cluster nodes"
  type          = list(object({
    name  = string
    ip    = string
    roles = string
  }))
}

###################################################################
# Rancher Custom Cluster Configuration
###################################################################

variable "enable_custom_k8s_cluster" {
  description   = "Enable or disable the creation/handling of a custom K8s cluster"
  type          = bool
  default       = false
}

variable "custom_k8s_nodes"  {
  description   = "Custom K8s cluster nodes"
  type          = list(object({
    name  = string
    ip    = string
    roles = string
  }))
}

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
