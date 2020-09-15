# Docker Installation Module
Installs Docker on (a) node(s).

## Example Usage
```
module "docker-rke-nodes" {
  source  = "./modules/docker"

  nodes   = {
    "rancher-node-0" = {
      ip    = "172.20.20.10",
      roles = ["controlplane","etcd","worker"]
    },
    "rancher-node-1" = {
      ip    = "172.20.20.11",
      roles = ["worker"]
    }
  }
}
```