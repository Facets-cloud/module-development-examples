# Azure VNet Module

This module creates a Virtual Network (VNet) and a subnet on Azure. It is designed to be used within the Facets framework, providing a customizable network environment for deploying resources.

## Functionality

- Creates a VNet with a specified address space.
- Provisions a subnet within the VNet with a specified address prefix.

## Configurability

- **Address Space**: Define the network range for the VNet.
- **Subnet Prefix**: Specify the address prefix for the subnet.

## Usage

To use this module, include it in your Terraform configuration and provide the necessary inputs as defined in the `facets.yaml` file.

For more details on how to expose and consume providers, see [exposing_providers.md](../../exposing_providers.md).
