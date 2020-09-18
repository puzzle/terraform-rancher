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