variable "nodes"  {
  description   = "Nodes to install Docker on."
  type          = map(object({
    ip    = string
    roles = list(string)
  }))
}

variable "docker_version" {
  description   = "Docker version to install on nodes. Check https://github.com/rancher/install-docker for the newest Rancher supported Docker version."
  default       = "19.03.9"
}

variable "remote_access_service_user" {
  description   = "User which will be used to access the remote nodes. Will also be added to the docker group."
  default       = "vagrant"
}

variable "remote_access_service_user_priv_key" {
  description   = "Passwordless private key for a passwordless login of the remote node service user."
  default       = "~/.ssh/id_rsa"
}
