resource "null_resource" "firewalld_installation" {
  for_each = var.nodes
  connection {
    host        = each.value.ip
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum check-update",
      "sudo yum install firewalld",
      "sudo systemctl enable firewalld --now"
    ]
  }
}

# Wait for the Firewall service to start
resource "null_resource" "wait_for_firewalld" {}

resource "time_sleep" "wait_10_seconds_for_firewalld" {
  depends_on = [null_resource.firewalld_installation]
  destroy_duration = "10s"
}

# TODO: Only add nodes with specific role to each *_nodes list.
locals {
  etcd_nodes = var.nodes
  control_nodes = var.nodes
  worker_nodes = var.nodes
}

# FW rules according to https://rancher.com/docs/rancher/v2.x/en/installation/options/firewall/
resource "null_resource" "firewalld_etcd_node_rules" {
  for_each = local.control_nodes
  connection {
    host        = each.value.ip
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo firewall-cmd --permanent --add-port=22/tcp",
      "sudo firewall-cmd --permanent --add-port=2376/tcp",
      "sudo firewall-cmd --permanent --add-port=2379/tcp",
      "sudo firewall-cmd --permanent --add-port=2380/tcp",
      "sudo firewall-cmd --permanent --add-port=8472/udp",
      "sudo firewall-cmd --permanent --add-port=9099/tcp",
      "sudo firewall-cmd --permanent --add-port=10250/tcp"
    ]
  }
}

resource "null_resource" "firewalld_control_node_rules" {
  for_each = local.worker_nodes
  connection {
    host        = each.value.ip
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo firewall-cmd --permanent --add-port=22/tcp",
      "sudo firewall-cmd --permanent --add-port=80/tcp",
      "sudo firewall-cmd --permanent --add-port=443/tcp",
      "sudo firewall-cmd --permanent --add-port=2376/tcp",
      "sudo firewall-cmd --permanent --add-port=6443/tcp",
      "sudo firewall-cmd --permanent --add-port=8472/udp",
      "sudo firewall-cmd --permanent --add-port=9099/tcp",
      "sudo firewall-cmd --permanent --add-port=10250/tcp",
      "sudo firewall-cmd --permanent --add-port=10254/tcp",
      "sudo firewall-cmd --permanent --add-port=30000-32767/tcp",
      "sudo firewall-cmd --permanent --add-port=30000-32767/udp"
    ]
  }
}

resource "null_resource" "firewalld_worker_node_rules" {
  for_each = local.etcd_nodes
  connection {
    host        = each.value.ip
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo firewall-cmd --permanent --add-port=22/tcp",
      "sudo firewall-cmd --permanent --add-port=80/tcp",
      "sudo firewall-cmd --permanent --add-port=443/tcp",
      "sudo firewall-cmd --permanent --add-port=2376/tcp",
      "sudo firewall-cmd --permanent --add-port=8472/udp",
      "sudo firewall-cmd --permanent --add-port=9099/tcp",
      "sudo firewall-cmd --permanent --add-port=10250/tcp",
      "sudo firewall-cmd --permanent --add-port=10254/tcp",
      "sudo firewall-cmd --permanent --add-port=30000-32767/tcp",
      "sudo firewall-cmd --permanent --add-port=30000-32767/udp"
    ]
  }
}

resource "null_resource" "firewalld_reload" {
  for_each = var.nodes
  triggers = {
    etcd_nodes = null_resource.firewalld_etcd_node_rules[each.key].id
    control_nodes = null_resource.firewalld_etcd_node_rules[each.key].id
    worker_nodes = null_resource.firewalld_etcd_node_rules[each.key].id
  }
  connection {
    host        = each.value.ip
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo firewall-cmd --reload"
    ]
  }
}
