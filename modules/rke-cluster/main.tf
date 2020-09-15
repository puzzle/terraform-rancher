# Create a new RKE cluster using config yaml
resource "rke_cluster" "rancher-cp" {
  cluster_yaml = file("cluster.yml")
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.rancher-cp.kube_config_yaml
}

output "kubeconfig_rke_cluster" {
  value = rke_cluster.rancher-cp.kube_config_yaml
}