###################################################################
# General Configuration
###################################################################

variable "remote_access_service_user" {
  description   = "User which will be used to access the remote nodes"
  default       = "vagrant"
}

variable "remote_access_service_user_priv_key" {
  description   = "Passwordless private key for a passwordless login of the remote node service user."
  default       = "~/.ssh/id_rsa"
}

###################################################################
# RKE Rancher Control Plane Cluster Configuration
###################################################################

variable "enable_rke_k8s_cluster" {
  description   = "Enable or disable the creation/handling of a RKE K8s cluster"
  type          = bool
  default       = true
}

variable "rke_nodes"  {
  description   = "RKE cluster nodes"
  type          = map(object({
    ip    = string
    roles = list(string)
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
  type          = map(object({
    ip    = string
    roles = list(string)
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
