# Exposing Providers in Facets Terraform Modules

Facets Terraform Modules can expose providers for other modules to use, allowing for seamless integration and interoperability. This document explains the mechanism of exposing providers using the `gke_autopilot` module as an example.

## Understanding the Mechanism

In Facets, a module can expose providers by defining them in the `facets.yaml` file. This allows other modules to consume these providers, enabling them to interact with the resources managed by the module.

### Example: `gke_autopilot` Module

The `gke_autopilot` module exposes a Kubernetes provider using the outputs of the module. Here's how it's done:

#### HCL Way (in the Calling Parent Module)

In a typical Terraform setup, you might define a provider in the calling parent module like this:

```hcl
provider "helm" {
  kubernetes {
    host                   = module.gke_autopilot.attributes.endpoint
    cluster_ca_certificate = module.gke_autopilot.attributes.ca_certificate
    token                  = module.gke_autopilot.attributes.client_token
  }
}
```

This configuration is used in the calling parent module to configure the Helm provider, which in turn uses the Kubernetes provider attributes from the `gke_autopilot` module's outputs.

#### Facets YAML Equivalent

In the `facets.yaml` file, you define the provider exposure like this:

```yaml
outputs:
  default:
    type: "@outputs/kubernetes_cluster_details"
    providers:
      helm:
        source: hashicorp/helm
        version: 2.8.0
        attributes:
          kubernetes:
            host: attributes.endpoint
            cluster_ca_certificate: attributes.ca_certificate
            token: attributes.client_token
```

### Explanation

- **Outputs**: The `outputs` section in `facets.yaml` specifies the type of output and the providers that are exposed.
- **Providers**: Under `providers`, you define the provider you want to expose. In this case, it's the `helm` provider, which uses the Kubernetes provider attributes.
- **Attributes**: The `attributes` section maps the provider's configuration to the module's outputs. This ensures that the provider is correctly configured using the module's outputs.

## Consuming Exposed Providers

Modules that consume exposed providers can specify the providers they need in their `facets.yaml` file. This is done by mentioning the required providers along with the inputs.

### Example: Helm

If a module requires the Helm provider exposed by the `gke_autopilot` module, it can specify this requirement as follows:

```yaml
inputs:
  kubernetes_cluster_details:
    type: "@outputs/kubernetes_cluster_details"
    providers:
      - helm
```

### Explanation

- **Inputs**: The `inputs` section specifies the inputs required by the module.
- **Providers**: Under `providers`, you list the providers that the module needs. This ensures that the necessary providers are available for the module to function correctly.

By following these steps, you can effectively expose and consume providers in your Facets Terraform Modules, enabling greater flexibility and integration capabilities.
