locals {
  output_interfaces = {}
  output_attributes = {
    cluster_id     = google_container_cluster.this.id
    endpoint       = google_container_cluster.this.endpoint
    ca_certificate = base64decode(google_container_cluster.this.master_auth[0].cluster_ca_certificate)
    client_token   = data.google_client_config.default.access_token
  }
}
