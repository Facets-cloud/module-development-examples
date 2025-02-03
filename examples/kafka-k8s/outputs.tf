locals {
  output_interfaces = {
    cluster = {
      endpoint = join(",", [for svc in data.kubernetes_service.kafka_lb : svc.status.load_balancer[0].hostname])
      username = random_password.kafka_username.result
      password = random_password.kafka_password.result
    }
  }
  output_attributes = {}
}
