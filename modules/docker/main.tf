resource "null_resource" "docker_installation" {
  for_each = var.nodes
  connection {
    host        = each.value.ip
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum check-update",
      "sudo curl https://releases.rancher.com/install-docker/${var.docker_version}.sh | sh",
      "sudo usermod -aG docker ${var.remote_access_service_user}",
      "sudo systemctl enable docker --now"
    ]
  }
}