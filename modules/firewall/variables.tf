variable "nodes"  {
  description   = "Nodes which firewalld rules get managed"
  type          = map(object({
    ip    = string
    roles = list(string)
  }))
}

variable "remote_access_service_user" {
  description   = "User which will be used to access the remote nodes"
  default       = "vagrant"
}

variable "remote_access_service_user_priv_key" {
  description   = "Passwordless private key for a passwordless login of the remote node service user."
  default       = "~/.ssh/id_rsa"
}