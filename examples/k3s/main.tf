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
  cluster_ca_certificate = module.k3s.kubernetes.cluster_ca_certificate
  client_certificate     = module.k3s.kubernetes.client_certificate
  client_key             = module.k3s.kubernetes.client_key
}

resource "kubernetes_service_account" "facets-cp-admin" {
  depends_on = [module.k3s.kubernetes_ready]
  metadata {
    name = "facets-cp-admin"
  }

  lifecycle {
    ignore_changes = ["image_pull_secret"]
  }
}

resource "kubernetes_cluster_role_binding" "facets-cp-admin-crb" {
  metadata {
    name = "facets-cp-admin-crb"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.facets-cp-admin.metadata[0].name
    namespace = "default"
  }
}

resource "kubernetes_secret_v1" "facets-cp-admin-token" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = "facets-cp-admin"
    }
    name = "${kubernetes_service_account.facets-cp-admin.metadata[0].name}-secret"
  }
  type = "kubernetes.io/service-account-token"
}

resource "null_resource" "add-k8s-creds-backend" {
  depends_on = [kubernetes_secret_v1.facets-cp-admin-token]
  triggers = {
    k8s_host = module.k3s.kubernetes.api_endpoint
  }
  provisioner "local-exec" {
    command = <<EOF
curl -X POST "https://${var.cc_metadata.cc_host}/cc/v1/clusters/${var.cluster.id}/credentials" -H "accept: */*" -H "Content-Type: application/json" -d "{ \"kubernetesApiEndpoint\": \"${module.k3s.kubernetes.api_endpoint}\", \"kubernetesToken\": \"${kubernetes_secret_v1.facets-cp-admin-token.data["token"]}\"}" -H "X-DEPLOYER-INTERNAL-AUTH-TOKEN: ${var.cc_metadata.cc_auth_token}"
EOF
  }
}
