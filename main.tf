# Provider Definitions
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

# Install Docker on RKE Nodes
module "docker-rke-nodes" {
  source  = "./modules/docker"
  count   = var.enable_rke_k8s_cluster == true ? 1 : 0

  nodes   = var.rke_nodes
}

# Wait for the Docker services to start
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]
  count   = var.enable_rke_k8s_cluster == true ? 1 : 0
  destroy_duration = "30s"
}

# Deploy RKE Rancher Control Plane Cluster
# TODO: Generate cluster.yml configuration via rke provider agruments
module "rke-cluster" {
  source      = "./modules/rke-cluster"
  count       = var.enable_rke_k8s_cluster == true ? 1 : 0
  providers   = {
    rke = rke.rke_config
  }
}

# Install Docker on Custom Cluster Nodes
module "docker-k8s-nodes" {
  source  = "./modules/docker"
  count   = var.enable_custom_k8s_cluster == true ? 1 : 0

  nodes   = var.custom_k8s_nodes
}

# TODO: Create the Custom K8s Cluster

# Deploy infra applications on the Custom K8s Cluster
module "custom-cluster" {
  source    = "./modules/custom-cluster"
  count     = var.enable_custom_k8s_cluster == true ? 1 : 0
  providers = {
    rancher2 = rancher2.rancher2_config
  }
}
