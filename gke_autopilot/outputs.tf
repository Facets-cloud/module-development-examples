locals {
  output_interfaces = {}
  output_attributes = {
    cluster_id = google_container_cluster.this.id
  }
}
