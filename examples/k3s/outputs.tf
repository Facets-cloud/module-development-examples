locals {
  output_interfaces = {}

  output_attributes = {
    api_endpoint             = module.k3s.kubernetes.api_endpoint
    cluster_ca_certificate   = module.k3s.kubernetes.cluster_ca_certificate
    client_certificate       = module.k3s.kubernetes.client_certificate
    client_key               = module.k3s.kubernetes.client_key
  }
}
