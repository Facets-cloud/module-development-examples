# GKE Autopilot Module

This module creates a GKE Autopilot cluster on Google Cloud Platform. It is designed to be used within the Facets framework, providing a managed Kubernetes environment with minimal operational overhead.

## Functionality

- Creates a GKE Autopilot cluster with specified configurations.
- Integrates with existing GCP network configurations.

## Configurability

- **Network Details**: Requires GCP network details for cluster configuration.

## Usage

To use this module, include it in your Terraform configuration and provide the necessary inputs as defined in the `facets.yaml` file.

For more details on how to expose and consume providers, see [exposing_providers.md](../../exposing_providers.md).
