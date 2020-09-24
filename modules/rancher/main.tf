# Cert-Manager & Rancher Helm Chart Installation
resource "null_resource" "get_cert_manager_crds" {
  provisioner "local-exec" {
    command = "wget -P ${var.rancher_manifest_store_directory} https://github.com/jetstack/cert-manager/releases/download/${var.rancher_cert_manager_version}/cert-manager.crds.yaml"
  }
}

resource "kubectl_manifest" "apply_cert_manager_crds" {
  validate_schema = false
  yaml_body       = filebase64("${path.root}/${var.rancher_manifest_store_directory}/cert-manager.crds.yaml")
}

resource "helm_release" "cert_manager" {
  name              = "cert-manager"
  repository        = "https://kubernetes-charts.storage.googleapis.com" 
  chart             = "cert-manager"
  version           = var.rancher_cert_manager_version
  namespace         = "cert-manager"
  create_namespace  = true
  atomic            = true
  cleanup_on_fail   = true
  wait              = true
  timeout           = 600
}

resource "helm_release" "rancher" {
  name              = "rancher"
  repository        = "https://releases.rancher.com/server-charts/${var.rancher_helm_chart_type}"
  chart             = "rancher"
  version           = var.rancher_helm_chart_version
  namespace         = "cattle-system"
  create_namespace  = true
  atomic            = true
  cleanup_on_fail   = true
  wait              = true
  timeout           = 600

  # Values according to https://rancher.com/docs/rancher/v2.x/en/installation/options/chart-options/#common-options
  set {
    name  = "hostname"
    value = var.rancher_helm_chart_value_hostname
  }
  set {
    name  = "ingress.tls.source"
    value = var.rancher_helm_chart_value_ingress
  }
  set {
    name  = "letsEncrypt.email"
    value = var.rancher_helm_chart_value_letsencrypt_mail
  }
  set {
    name  = "letsEncrypt.environment"
    value = var.rancher_helm_chart_value_letsencrypt_env
  }
  set {
    name  = "privateCA"
    value = var.rancher_helm_chart_value_private_ca
  }
}

# TODO: Add keepalived as infrastructure app