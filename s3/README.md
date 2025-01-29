# S3 Bucket Module

This module creates an S3 bucket on AWS with configurable ACL, versioning, and server-side encryption.

## Variables

- **instance**: JSON representation of the resource in the facets blueprint.
- **instance_name**: Architectural name for the resource.
- **environment**: Details about the environment.
- **inputs**: Map of inputs requested by the module developer.

## Outputs

- **bucket_name**: The name of the created S3 bucket.
- **arn**: The ARN of the created S3 bucket.

## Usage

To use this module, include it in your Terraform configuration and provide the necessary variables.

## Example

```hcl
module "s3_bucket" {
  source = "../"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "test-bucket"
  environment = {
    name        = "test"
    unique_name = "project_test"
  }
  inputs = {}
}
```
# S3 Bucket Module

This module creates an S3 bucket on AWS with configurable access control, versioning, and server-side encryption. It is designed to be used within the Facets framework, providing a flexible and secure storage solution.

## Functionality

- Creates an S3 bucket with specified configurations.
- Supports access control, versioning, and server-side encryption.

## Configurability

- **ACL**: Set the access control list for the bucket (e.g., private, public-read).
- **Versioning**: Enable or disable versioning for the bucket.
- **Server-Side Encryption**: Specify the encryption algorithm (e.g., AES256, aws:kms).
