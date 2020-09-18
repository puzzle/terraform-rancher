##################################################
# Provider Definitions
##################################################
provider "rke" {
  alias     = "rke_config"
  log_file  = "rke_debug.log"
}

provider "rancher2" {
  alias       = "rancher2_config"
  api_url     = var.rancher2_api_url
  access_key  = var.rancher2_access_key
  secret_key  = var.rancher2_secret_key
}

##################################################
# RKE K8s Cluster
##################################################

# Install Docker on RKE Nodes
module "docker-rke-nodes" {
  source  = "./modules/docker"
  count   = var.enable_rke_k8s_cluster == true ? 1 : 0

  nodes                                = var.rke_cluster_nodes
  remote_access_service_user           = var.remote_access_service_user
  remote_access_service_user_priv_key  = var.remote_access_service_user_priv_key
}

# Wait for the Docker services to start
resource "null_resource" "wait_for_rke_dockers" {}

resource "time_sleep" "wait_15_seconds_for_rke_dockers" {
  depends_on        = [null_resource.wait_for_rke_dockers]
  count             = var.enable_rke_k8s_cluster == true ? 1 : 0
  destroy_duration  = "15s"
}

module "rke-node-firewall" {
  source  = "./modules/firewall"
  count   = var.enable_rke_k8s_cluster == true ? 1 : 0

  nodes   = var.rke_cluster_nodes
}

# Deploy RKE Rancher Control Plane Cluster
module "rke-cluster" {
  source      = "./modules/rke-cluster"
  count       = var.enable_rke_k8s_cluster == true ? 1 : 0
  providers   = {
    rke = rke.rke_config
  }

  rke_cluster_node_config_is_from_cluster_yml = var.rke_cluster_node_config_is_from_cluster_yml
  rke_cluster_yml_file                        = var.rke_cluster_yml_file
  rke_cluster_nodes                           = var.rke_cluster_nodes
  rke_cluster_node_service_user               = var.rke_cluster_node_service_user
  rke_cluster_kubernetes_version              = var.rke_cluster_kubernetes_version
  rke_cluster_ingress_provider                = var.rke_cluster_ingress_provider
  rke_cluster_network_plugin                  = var.rke_cluster_network_plugin

}

# TODO: Install Rancher Helm Chart & dependencies

# TODO: Add keepalived as infrastructure app

##################################################
# Custom K8s Cluster
##################################################

# Install Docker on Custom Cluster Nodes
module "docker-k8s-nodes" {
  source  = "./modules/docker"
  count   = var.enable_custom_k8s_cluster == true ? 1 : 0

  nodes                               = var.custom_cluster_nodes
  remote_access_service_user          = var.remote_access_service_user
  remote_access_service_user_priv_key = var.remote_access_service_user_priv_key
}

# Wait for the Docker services to start
resource "null_resource" "wait_for_custom_dockers" {}

resource "time_sleep" "wait_15_seconds_for_custom_dockers" {
  depends_on = [null_resource.wait_for_custom_dockers]
  count   = var.enable_custom_k8s_cluster == true ? 1 : 0
  destroy_duration = "15s"
}

module "custom-node-firewall" {
  source      = "./modules/firewall"
  count       = var.enable_custom_k8s_cluster == true ? 1 : 0

  nodes       = var.custom_cluster_nodes
}

# TODO: Create the Custom K8s Cluster

# Deploy infra applications on the Custom K8s Cluster
# TODO: Add keepalived as infrastructure app
module "custom-cluster" {
  source    = "./modules/custom-cluster"
  count     = var.enable_custom_k8s_cluster == true ? 1 : 0
  providers = {
    rancher2 = rancher2.rancher2_config
  }
}
