resource "google_compute_network" "this" {
  name                    = "${var.environment.unique_name}-${var.instance_name}"
  auto_create_subnetworks = false
  region       = var.instance.spec.region
}

resource "google_compute_subnetwork" "this" {
  name          = "${var.environment.unique_name}-${var.instance_name}-subnet"
  ip_cidr_range = var.instance.spec.cidr
  network       = google_compute_network.this.id
}
