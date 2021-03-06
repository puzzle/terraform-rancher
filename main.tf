##################################################
# Provider Definitions
##################################################
provider "rke" {
  log_file  = "rke_debug.log"
}

provider "helm" {
  kubernetes {
    config_path = "${path.root}/kube_config_cluster.yml"
  }
}

provider "rancher2" {
  api_url     = var.rancher2_api_url
  access_key  = var.rancher2_access_key
  secret_key  = var.rancher2_secret_key
}

provider "kubectl" {
  config_path = "${path.root}/kube_config_cluster.yml"
}

##################################################
# RKE K8s Cluster
##################################################

# Handle Rancher & K8s related firewall configuration
module "rke_node_firewall" {
  source  = "./modules/firewall"
  count   = var.enable_rke_k8s_cluster == true ? 1 : 0

  nodes   = var.rke_cluster_nodes
}

# Install Docker on RKE Nodes
module "docker_rke_nodes" {
  source  = "./modules/docker"
  count   = var.enable_rke_k8s_cluster == true ? 1 : 0

  nodes                                = var.rke_cluster_nodes
  remote_access_service_user           = var.remote_access_service_user
  remote_access_service_user_priv_key  = var.remote_access_service_user_priv_key
}

# Wait for the Docker services to start
resource "time_sleep" "wait_15_seconds_for_rke_dockers" {
  depends_on        = [module.docker_rke_nodes]
  count             = var.enable_rke_k8s_cluster == true ? 1 : 0
  create_duration  = "15s"
}

# Deploy RKE Rancher Control Plane Cluster
module "rke_cluster" {
  source      = "./modules/rke-cluster"
  count       = var.enable_rke_k8s_cluster == true ? 1 : 0

  rke_cluster_node_config_is_from_cluster_yml = var.rke_cluster_node_config_is_from_cluster_yml
  rke_cluster_yml_file                        = var.rke_cluster_yml_file
  rke_cluster_nodes                           = var.rke_cluster_nodes
  rke_cluster_node_service_user               = var.rke_cluster_node_service_user
  rke_cluster_kubernetes_version              = var.rke_cluster_kubernetes_version
  rke_cluster_ingress_provider                = var.rke_cluster_ingress_provider
  rke_cluster_network_plugin                  = var.rke_cluster_network_plugin
}

# Wait for the RKE cluster to properly start
resource "time_sleep" "wait_15_seconds_for_rke_cluster" {
  depends_on        = [module.rke_cluster]
  count             = var.enable_rke_k8s_cluster == true ? 1 : 0
  create_duration  = "15s"
}

# Deploy Rancher Control Plane
module "rancher" {
  source      = "./modules/rancher"
  count       = var.enable_rke_k8s_cluster == true ? 1 : 0

  rancher_manifest_store_directory          = var.rancher_manifest_store_directory
  rancher_cert_manager_version              = var.rancher_cert_manager_version
  rancher_helm_chart_version                = var.rancher_helm_chart_version
  rancher_helm_chart_type                   = var.rancher_helm_chart_type

  rancher_helm_chart_value_hostname         = var.rancher_helm_chart_value_hostname
  rancher_helm_chart_value_ingress          = var.rancher_helm_chart_value_ingress
  rancher_helm_chart_value_letsencrypt_mail = var.rancher_helm_chart_value_letsencrypt_mail
  rancher_helm_chart_value_letsencrypt_env  = var.rancher_helm_chart_value_letsencrypt_env
  rancher_helm_chart_value_private_ca       = var.rancher_helm_chart_value_private_ca
}

##################################################
# Custom K8s Cluster
##################################################

# Handle Rancher & K8s related firewall configuration
module "custom_node_firewall" {
  source      = "./modules/firewall"
  count       = var.enable_custom_k8s_cluster == true ? 1 : 0

  nodes       = var.custom_cluster_nodes
}

# Install Docker on Custom Cluster Nodes
module "docker_k8s_nodes" {
  source  = "./modules/docker"
  count   = var.enable_custom_k8s_cluster == true ? 1 : 0

  nodes                               = var.custom_cluster_nodes
  remote_access_service_user          = var.remote_access_service_user
  remote_access_service_user_priv_key = var.remote_access_service_user_priv_key
}

# Wait for the Docker services to start
resource "time_sleep" "wait_15_seconds_for_custom_dockers" {
  depends_on = [module.docker_k8s_nodes]
  count   = var.enable_custom_k8s_cluster == true ? 1 : 0
  create_duration = "15s"
}

# TODO: Create the Custom K8s Cluster

# Deploy infra applications on the Custom K8s Cluster
# TODO: Add keepalived as infrastructure app
module "custom_cluster" {
  source    = "./modules/custom-cluster"
  count     = var.enable_custom_k8s_cluster == true ? 1 : 0
}
