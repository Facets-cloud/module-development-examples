resource "google_container_cluster" "this" {
  name     = var.instance.spec.cluster_name
  location = "us-central1"

  autopilot {
    enabled = true
  }

  network    = var.inputs["gcp_network_details"].attributes["network_id"]
  subnetwork = var.inputs["gcp_network_details"].attributes["subnet_id"]
}
