# GCP Network Module

This module creates a network and subnetwork on Google Cloud Platform. It is designed to be used within the Facets framework, providing a customizable network environment for deploying resources.

## Functionality

- Creates a GCP network with a specified CIDR block.
- Provisions a subnetwork within the specified region.

## Configurability

- **CIDR Block**: Define the network range for the GCP network.
- **Region**: Specify the region for the subnetwork.

## Usage

To use this module, include it in your Terraform configuration and provide the necessary inputs as defined in the `facets.yaml` file.

For more details on how to expose and consume providers, see [exposing_providers.md](../../exposing_providers.md).
