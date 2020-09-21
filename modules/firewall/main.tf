resource "null_resource" "firewalld_installation" {
  for_each = var.nodes
  connection {
    host        = each.value.address
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
resource "time_sleep" "wait_10_seconds_for_firewalld" {
  depends_on = [null_resource.firewalld_installation]
  create_duration = "10s"
}

locals {
  etcd_nodes = {
    for node, obj in var.nodes : node => {
        address = obj.address
        role    = obj.role
      } if contains(obj.role, "etcd")
  }
  control_nodes = {
    for node, obj in var.nodes : node => {
        address = obj.address
        role    = obj.role
      } if contains(obj.role, "controlplane")
  }
  worker_nodes = {
    for node, obj in var.nodes : node => {
        address = obj.address
        role    = obj.role
      } if contains(obj.role, "worker")
  }
}

# FW rules according to https://rancher.com/docs/rancher/v2.x/en/installation/options/firewall/
resource "null_resource" "firewalld_etcd_node_rules" {
  depends_on = [time_sleep.wait_10_seconds_for_firewalld]
  for_each = local.etcd_nodes
  connection {
    host        = each.value.address
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
  depends_on = [time_sleep.wait_10_seconds_for_firewalld]
  for_each = local.control_nodes
  connection {
    host        = each.value.address
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
  depends_on = [time_sleep.wait_10_seconds_for_firewalld]
  for_each = local.worker_nodes
  connection {
    host        = each.value.address
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

# Wait for Firewall rules to be applied properly
resource "time_sleep" "wait_5_seconds_for_firewalld_rules" {
  depends_on = [
    null_resource.firewalld_etcd_node_rules,
    null_resource.firewalld_control_node_rules,
    null_resource.firewalld_worker_node_rules
  ]
  create_duration = "5s"
}

# Reload the firewall configuration and restart the Docker daemon in order to reapply its chains
# TODO: Resolve the Docker & Firewalld issue where the Docker chains always get deleted after firewalld is restarted.
resource "null_resource" "firewalld_reload" {
  depends_on = [time_sleep.wait_5_seconds_for_firewalld_rules]
  for_each = var.nodes
  triggers = {
    etcd_nodes = lookup(local.etcd_nodes, each.key, null) != null ? null_resource.firewalld_etcd_node_rules[each.key].id : ""
    control_nodes = lookup(local.control_nodes, each.key, null) != null ? null_resource.firewalld_control_node_rules[each.key].id : ""
    worker_nodes = lookup(local.worker_nodes, each.key, null) != null ? null_resource.firewalld_worker_node_rules[each.key].id : ""
  }
  connection {
    host        = each.value.address
    user        = var.remote_access_service_user
    private_key = file(var.remote_access_service_user_priv_key)
  }
  provisioner "remote-exec" {
    inline = [
      "sudo firewall-cmd --reload",
      "sudo systemctl restart docker || true"
    ]
  }
}
