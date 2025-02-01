locals {
  output_interfaces = {}

  output_attributes = {
    api_endpoint             = module.k3s.kubernetes.api_endpoint
    cluster_ca_certificate   = module.k3s.kubernetes.cluster_ca_certificate
    client_certificate       = module.k3s.kubernetes.client_certificate
    client_key               = module.k3s.kubernetes.client_key
    legacy_outputs           = {
      "registry_secret_objects" = [],
    }
    kube_config_base64       = base64encode(module.k3s.kube_config)
    lb_service_record_type   = "A"
    secrets                  = ["cluster_ca_certificate", "client_certificate", "client_key", "kube_config_base64"]
  }
}
