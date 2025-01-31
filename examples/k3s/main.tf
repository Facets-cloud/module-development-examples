module "k3s" {
  source = "./terraform-module-k3s"

  servers = {
    for name, node in var.instance.spec.master_nodes : name => {
      ip = node.host
      connection = {
        host        = node.host
        user        = node.username
        private_key = base64decode(node.private_key)
      }
      # Add other fields like flags, annotations, labels, taints if needed
    }
  }

  agents = {
    for name, node in var.instance.spec.agent_nodes : name => {
      ip = node.host
      connection = {
        host        = node.host
        user        = node.username
        private_key = base64decode(node.private_key)
      }
      # Add other fields if needed
    }
  }

  use_sudo = true
}
