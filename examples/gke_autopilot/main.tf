data "google_client_config" "default" {}

resource "google_container_cluster" "this" {
  name     = var.instance.spec.cluster_name
  location = var.inputs["gcp_network_details"].attributes["region"]

  enable_autopilot = true

  network    = var.inputs["gcp_network_details"].attributes["network_id"]
  subnetwork = var.inputs["gcp_network_details"].attributes["subnet_id"]
}
