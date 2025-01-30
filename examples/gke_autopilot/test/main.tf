provider "google" {
  credentials = file("<path-to-your-service-account-key>")
  project     = "<your-gcp-project-id>"
  region      = "us-central1"
}

module "gcp_network" {
  source = "../gcp_network"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "test-network"
  environment = {
    name        = "test"
    unique_name = "project_test"
  }
  inputs = {}
}

module "gke_autopilot" {
  source = "../gke_autopilot"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "test-cluster"
  environment = {
    name        = "test"
    unique_name = "project_test"
  }
  inputs = {
    gcp_network_details = module.gcp_network.outputs
  }
}
