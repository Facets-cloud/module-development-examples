# Azure VMSS Module

This module creates a Virtual Machine Scale Set (VMSS) on Azure with public IPs for each instance. It is designed to be used within the Facets framework, providing a scalable and flexible environment for deploying applications.

## Functionality

- Creates a VMSS with a specified VM size and instance count.
- Assigns a public IP to each instance in the scale set.

## Configurability

- **VM Size**: Specify the size of the VMs in the scale set.
- **Instance Count**: Define the number of instances in the scale set.
- **Admin Username**: Set the admin username for the VMs.
- **Admin Password**: Set the admin password for the VMs.

## Usage

To use this module, include it in your Terraform configuration and provide the necessary inputs as defined in the `facets.yaml` file.

For more details on how to expose and consume providers, see [exposing_providers.md](../../exposing_providers.md).
