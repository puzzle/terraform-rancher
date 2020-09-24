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
# Rancher Installation Configuration
###################################################################
variable "rancher_manifest_store_directory" {
  description   = "Directory where to download K8s manifests to (without leading/trailing '/')"
  type          = string
  default       = "values_yaml"
}

variable "rancher_cert_manager_version" {
  description   = "Cert-Manager version for the Rancher Helm installation"
  type          = string
  default       = "v1.0.2"
}

variable "rancher_helm_chart_version" {
  description   = "Rancher Helm chart version for the Rancher Helm installation"
  type          = string
  default       = "v2.4.8"
}

variable "rancher_helm_chart_type" {
  description   = "Rancher Helm chart type (latest or stable) for the Rancher Helm installation"
  type          = string
  default       = "stable"
}

# See https://rancher.com/docs/rancher/v2.x/en/installation/options/chart-options/#common-options for more details about the Rancher Helm chart values
variable "rancher_helm_chart_value_hostname" {
  description   = "Rancher Helm chart value for hostname"
  type          = string
  default       = "rancher.127.0.0.1.xio.puzzle.ch"
}

variable "rancher_helm_chart_value_ingress" {
  description   = "Rancher Helm chart value for ingress.tls.source"
  type          = string
  default       = "letsEncrypt"
}

variable "rancher_helm_chart_value_letsencrypt_mail" {
  description   = "Rancher Helm chart value for letsEncrypt.email"
  type          = string
  default       = ""
}

variable "rancher_helm_chart_value_letsencrypt_env" {
  description   = "Rancher Helm chart value for letsEncrypt.environment"
  type          = string
  default       = "staging"
}

variable "rancher_helm_chart_value_private_ca" {
  description   = "Rancher Helm chart value for privateCA"
  type          = bool
  default       = true
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