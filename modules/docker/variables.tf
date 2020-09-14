variable "nodes"  {
  description   = "Nodes to install Docker on."
  type          = list(object({
    name  = string
    ip    = string
    roles = string
  }))
}

variable "docker_version" {
  description   = "Docker version to install on nodes. Check https://github.com/rancher/install-docker for the newest Rancher supported Docker version."
  default       = "19.03.9"
}

variable "docker_service_user" {
  description   = "User which will to be added to the docker group."
  default       = "vagrant"
}

variable "docker_service_user_priv_key" {
  description   = "Passwordless private key for a passwordless login of the service user."
  default       = "~/.ssh/id_rsa"
}
