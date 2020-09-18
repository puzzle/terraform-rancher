###################################################################
# General Configuration
###################################################################

variable "remote_access_service_user" {
  description   = "User which will be used to access the remote nodes"
  type          = string
  default       = "vagrant"
}

variable "remote_access_service_user_priv_key" {
  description   = "Passwordless private key for a passwordless login of the remote node service user."
  type          = string
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

variable "rke_cluster_node_config_is_from_cluster_yml" {
  description   = "Choose if rke node config should be taken from rke_cluster_yml_file or rke_cluster_nodes. Default is rke_cluster_yml_file."
  type          = bool
  default       = true
}

variable "rke_cluster_yml_file" {
  description   = "RKE cluster.yml configuration file name. rke_cluster_yml_file OR rke_cluster_nodes is required."
  type          = string
  default       = "cluster.yml"
}

variable "rke_cluster_nodes"  {
  description   = "RKE cluster nodes. rke_cluster_yml_file OR rke_cluster_nodes is required."
  type          = map(object({
    address = string
    role    = list(string)
  }))
  default = {}
}

variable "rke_cluster_node_service_user" {
  description   = "RKE cluster node service user. Used to the RKE SSH session to the node."
  type          = string
  default       = "vagrant"
}

variable "rke_cluster_kubernetes_version" {
  description   = "Kubernetes version of the RKE cluster"
  type          = string
  default       = "v1.18.6-rancher1-2"
}

variable "rke_cluster_ingress_provider" {
  description   = "RKE cluster ingress provider"
  type          = string
  default       = "nginx"
}

variable "rke_cluster_network_plugin" {
  description   = "RKE cluster cni plugin"
  type          = string
  default       = "canal"
}

###################################################################
# Rancher Custom Cluster Configuration
###################################################################

variable "enable_custom_k8s_cluster" {
  description   = "Enable or disable the creation/handling of a custom K8s cluster"
  type          = bool
  default       = false
}

variable "custom_cluster_nodes"  {
  description   = "Custom K8s cluster nodes"
  type          = map(object({
    address = string
    role    = list(string)
  }))
  default = {}
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

variable "custom_kubernetes_version" {
  description   = "Kubernetes version of the custom cluster"
  type          = string
  default       = "v1.18.8-rancher1-1"
}