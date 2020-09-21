output "etcd_nodes" {
  value = module.rke_node_firewall.*.etcd_nodes
}

output "control_nodes" {
  value = module.rke_node_firewall.*.control_nodes
}

output "worker_nodes" {
  value = module.rke_node_firewall.*.etcd_nodes
}