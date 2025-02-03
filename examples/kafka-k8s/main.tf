resource "random_password" "kafka_username" {
  length  = 8
  special = false
}

resource "random_password" "kafka_password" {
  length  = 16
  special = true
}

resource "helm_release" "kafka" {
  name       = "${var.instance_name}-${var.environment.unique_name}"
  namespace  = var.kubernetes_namespace
  chart      = "oci://registry-1.docker.io/bitnamicharts/kafka"
  version    = var.instance.spec.version

  values = [
    yamlencode({
      replicaCount = var.instance.spec.nodes
      resources = {
        requests = {
          cpu    = var.instance.spec.cpu
          memory = var.instance.spec.memory
        }
      }
      externalAccess = {
        enabled = true
        autoDiscovery = {
          enabled = true
        }
        service = {
          type = "LoadBalancer"
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-internal" = "true"
            "service.beta.kubernetes.io/azure-load-balancer-internal" = "true"
            "networking.gke.io/internal-load-balancer" = "true"
          }
        }
      }
      auth = {
        enabled = var.instance.spec.authentication_method == "sasl"
        sasl = {
          jaas = {
            clientUsers = [random_password.kafka_username.result]
            clientPasswords = [random_password.kafka_password.result]
          }
        }
      }
    }),
    var.instance.spec.custom_chart_values
  ]
}

data "kubernetes_service" "kafka_lb" {
  for_each = { for i in range(var.instance.spec.nodes) : i => i }

  metadata {
    name      = "${helm_release.kafka.name}-${each.key}-external"
    namespace = var.kubernetes_namespace
  }
}
