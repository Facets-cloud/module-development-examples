module "k3s" {
  source = "./terraform-module-k3s"

  servers = {
    for name, node in var.instance.spec.master_nodes : name => {
      ip = node.private_ip
      connection = {
        host        = node.public_ip
        user        = node.username
        private_key = base64decode(node.private_key)
      }

      flags = [
        "--tls-san ${node.public_ip}",
        "--node-external-ip ${node.public_ip}",
        "--disable=traefik"
      ]
    }
  }

  agents = {
    for name, node in var.instance.spec.agent_nodes : name => {
      ip = node.private_ip
      connection = {
        host        = node.public_ip
        user        = node.username
        private_key = base64decode(node.private_key)
      }
      
      flags = [
        "--node-external-ip ${node.public_ip}"
      ]
    }
  }

  use_sudo = true
}

provider "kubernetes" {
  host                   = module.k3s.kubernetes.api_endpoint
  cluster_ca_certificate = base64decode(module.k3s.kubernetes.cluster_ca_certificate)
  client_certificate     = base64decode(module.k3s.kubernetes.client_certificate)
  client_key             = base64decode(module.k3s.kubernetes.client_key)
}
