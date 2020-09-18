# Create a new RKE cluster using config yaml
resource "rke_cluster" "rancher-cp" {
  cluster_yaml        = var.rke_cluster_node_config_is_from_cluster_yml ? file(var.rke_cluster_yml_file) : null
  dynamic nodes {
    for_each  = var.rke_cluster_node_config_is_from_cluster_yml ? {} : var.rke_cluster_nodes
    content {
      address = nodes.value.address
      user    = var.rke_cluster_node_service_user
      role    = nodes.value.role
    }
  }
  kubernetes_version  = var.rke_cluster_kubernetes_version

  ingress {
    provider = var.rke_cluster_ingress_provider
  }
  network {
    plugin = var.rke_cluster_network_plugin
  }
}

resource "local_file" "rke_state" {
  filename        = "${path.root}/.rkestate"
  content         = rke_cluster.rancher-cp.rke_state
  file_permission = "0664"
}

resource "local_file" "rke_cluster_yaml" {
  filename        = "${path.root}/cluster.yml.bkp"
  content         = rke_cluster.rancher-cp.rke_cluster_yaml
  file_permission = "0664"
}

resource "local_file" "kube_cluster_yaml" {
  filename        = "${path.root}/kube_config_cluster.yml"
  content         = rke_cluster.rancher-cp.kube_config_yaml
  file_permission = "0664"
}

output "rke_state" {
  value = rke_cluster.rancher-cp.rke_state
}

output "rke_cluster_yaml" {
  value = rke_cluster.rancher-cp.rke_cluster_yaml
}

output "kubeconfig_rke_cluster" {
  value = rke_cluster.rancher-cp.kube_config_yaml
}