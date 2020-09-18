resource "null_resource" "docker_installation" {
  for_each = var.nodes
  connection {
    host        = each.value.address
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum check-update",
      "sudo curl https://releases.rancher.com/install-docker/${var.docker_version}.sh | sh",
      "sudo usermod -aG docker ${var.remote_access_service_user}",
      "echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf",
      "sudo systemctl enable docker --now"
    ]
  }
}

resource "null_resource" "docker_cleanup_cronjobs" {
  for_each = var.nodes
  connection {
    host        = each.value.address
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "crontab -l | { cat; echo '0 21 * * * /bin/docker system prune -f --filter until=2h -a >/dev/null 2>&1'; } | crontab -",
      "crontab -l | { cat; echo '15 21 * * * for vol in $(/bin/docker volume ls -q -f dangling=true); do /bin/docker volume rm $vol >/dev/null 2>&1; done'; } | crontab -"
    ]
  }
}