# Terraform Resources for Rancher K8s Clusters

**Disclaimer!**: We use this as a base for our own and customer setup at puzzle. **Heavy work in progress** and a lot of things that can be improved. Feel free to contribute. We are happy to assist.

These Terraform resource definitions can be used to:

- deploy a RKE based Rancher Control Plane K8s cluster
- add a custom K8s cluster to an existing Rancher Control Plane

## Prerequisites

### Installation- / Jump-Host
1. Install Terraform on your local workstation (version >= 0.13): https://www.terraform.io/downloads.html

2. Copy the template terraform "tfvars" file (`terraform.tfvars.tmpl`) to `terraform.tfvars` and adjust the values according to your environment. Further configuration values can be seen inside `variables.tf` and then also be overridden inside `terraform.tfvars`.
```bash
cp terraform.tfvars.tmpl terraform.tfvars
```

3. Initialize Terraform:
```bash
terraform init
```

## Getting Started
1. Test the Terraform changes by running `terraform plan`
```bash
terraform plan
```

2. If the Terraform plan output looks good start with the cluster creation:
```bash
terraform apply
```

3. Configure your `kubectl` to use the generated `kube_config_cluster.yml` from the RKE K8s cluster:
```bash
$ export KUBECONFIG=$(pwd)/kube_config_cluster.yml
$ kubectl get nodes
NAME                         STATUS   ROLES                      AGE     VERSION
172.20.20.10.xip.puzzle.ch   Ready    controlplane,etcd,worker   3m29s   v1.18.6
```

## License

GPLv3

## Author Information

- Philip Schmid