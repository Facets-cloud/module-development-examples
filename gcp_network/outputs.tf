locals {
  output_interfaces = {}
  output_attributes = {
    network_id = google_compute_network.this.id
    subnet_id  = google_compute_subnetwork.this.id
  }
}
