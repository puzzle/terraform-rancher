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
