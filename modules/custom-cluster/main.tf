## Catalog
################################################
resource "rancher2_catalog" "appuio" {
  name     = "appuio"
  url      = "https://charts.appuio.ch"
  version  = "helm_v3"
}

resource "rancher2_catalog" "bitnami" {
  name     = "bitnami"
  url      = "https://charts.bitnami.com/bitnami"
  version  = "helm_v3"
}

resource "rancher2_catalog" "gitlab" {
  name     = "gitlab"
  url      = "https://charts.gitlab.io/"
  version  = "helm_v3"
}

resource "rancher2_catalog" "harbor" {
  name     = "harbor"
  url      = "https://helm.goharbor.io"
  version  = "helm_v3"
}

resource "rancher2_catalog" "keel" {
  name     = "keel"
  url      = "https://charts.keel.sh"
  version  = "helm_v3"
}

resource "rancher2_catalog" "loki" {
  name     = "loki"
  url      = "https://grafana.github.io/loki/charts"
  version  = "helm_v3"
}

resource "rancher2_catalog" "puzzle" {
  name     = "puzzle"
  url      = "https://charts.k8s.puzzle.ch"
  version  = "helm_v3"
}

resource "rancher2_catalog" "jetstack" {
  name     = "jetstack"
  url      = "https://charts.jetstack.io"
  version  = "helm_v3"
}

resource "rancher2_catalog" "ingress_nginx" {
  name     = "ingress-nginx"
  url      = "https://kubernetes.github.io/ingress-nginx"
  version  = "helm_v3"
}

## Apps
################################################
data "rancher2_cluster" "testing_cluster" {
  name = "testing-cluster"
}

data "rancher2_project" "testing_cluster_infra" {
    cluster_id = data.rancher2_cluster.testing_cluster.id
    name = "infra"
}

data "rancher2_project" "testing_cluster_system" {
    cluster_id = data.rancher2_cluster.testing_cluster.id
    name = "System"
}

resource "rancher2_app" "nginx_ingress" {
  catalog_name = "ingress-nginx"
  name = "nginx-ingress"
  project_id = data.rancher2_project.testing_cluster_infra.id
  template_name = "ingress-nginx"
  template_version = "2.15.0"
  target_namespace = "nginx-ingress"
  values_yaml = filebase64("${path.module}/values_yaml/infra_nginx_ingress.yaml")
}
