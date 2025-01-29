# VPC Module

This module creates a Virtual Private Cloud (VPC) and associated subnets on AWS. It is designed to be used within the Facets framework, providing a customizable network environment for deploying resources.

## Functionality

- Creates a VPC with a specified CIDR block.
- Automatically provisions subnets within the VPC.

## Configurability

- **CIDR Block**: Define the network range for the VPC.
- **Subnets**: Automatically created based on the specified CIDR block.
