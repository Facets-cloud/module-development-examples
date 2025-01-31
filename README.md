### Introduction

This repository is a comprehensive guide for writing, testing, and using Facets Terraform modules. It introduces the principles of module development through various examples. The primary goal is to enable platform engineers to create reusable modules that developers can easily consume via the Facets Blueprint Designer UI. This empowers developers to construct custom architectures, while the Facets platform automates the generation of project-specific Infrastructure as Code (IaC) necessary to manage environments based on these blueprints.

**Note:** These modules are intended for instructive purposes only and should not be used for any practical application. They serve as examples to demonstrate the concepts and practices of module development.

### Overview

This repository contains multiple examples of Facets Terraform modules, including `s3`, `ecs_cluster`, `ecs_service`, and `vpc`. Each module is located in its respective directory and demonstrates different capabilities and configurations.

| Example                  | Constructs Users Can Learn From                              |
|--------------------------|--------------------------------------------------------------|
| [`s3`](examples/s3)      | Defining user inputs and exposing outputs for other modules  |
| [`ecs_service`](examples/ecs_service) | Consuming inputs and outputs from other modules  |
| [`vpc`](examples/vpc)    | Defining user inputs and exposing outputs for other modules  |
| [`ecs_cluster`](examples/ecs_cluster) | Exposing outputs for other modules to consume    |
| [`gke_autopilot`](examples/gke_autopilot) | Exposing and consuming providers              |
| [`azure_vnet`](examples/azure_vnet) | Defining user inputs and exposing outputs         |
| [`azure_vmss`](examples/azure_vmss) | Consuming inputs and exposing outputs             |
| [`gcp_network`](examples/gcp_network) | Defining user inputs and exposing outputs        |
| [`k3s`](examples/k3s)    | Provisioning a k3s cluster and exposing Kubernetes and Helm providers |

Future updates will include features such as exposing providers as outputs of modules and advanced configurability of the UI rendered for each module spec in the Facets control plane.

### Concepts

1. **Blueprint**:
   - A blueprint in Facets represents the architecture of a cloud application. It is a high-level design that outlines how various resources are organized and interact within the cloud environment.
   - Blueprints are created using the Facets Blueprint Designer, where users can add and link resources together to form a cohesive architecture.
   - Each blueprint is stored as a git repository, and it generates JSON files for each resource included in the design.

2. **Blueprint Resource**:
   - Resources are the building blocks of a blueprint. Each resource type is powered by an underlying Facets Terraform module.
   - When a user adds a resource to a blueprint, a JSON object is generated for that resource. This JSON object becomes one of the variables automatically passed to the corresponding Terraform module (in var.instance.spec as you will soon learn).
   - The structure of the resource JSON includes:
     - `kind`: Specifies the intent of the module, such as `mysql`, `s3`, etc.
     - `flavor`: Indicates the specific implementation of the intent, such as `rds`, `aurora`, etc.
     - `version`: Specifies the version of the flavor.
     - `spec`: An object where the resource configuration is captured. The fields within this object are described by the underlying module's `facets.yaml`.

3. **Intent**:
   - An intent tells the type of resource. It represents a specific capability or function that a module is designed to provide, such as `mysql`, `postgres`, etc.
   - Intents define the purpose of a module and what it aims to achieve.
   - Modules implementing the same intent should adhere to a common output structure to ensure interoperability, allowing them to be interchangeable within a system.
   - You can list available intents using the following command:
     ```bash
     curl -s https://facets-cloud.github.io/facets-schemas/scripts/list-intents.sh | bash -s -- -c <control_plane_url> -u <username> -t <token>
     ```

4. **Flavor**:
   - A flavor selects the specific implementation of an intent.
   - For example, if the intent is `mysql`, flavors might include `rds` or `aurora`.
   - Each flavor is backed by a Facets Terraform module. Flavors allow for different technologies or approaches to fulfill the same intent, providing flexibility in how the intent is realized.

5. **Version**:
   - Versions indicate the iteration or release of a flavor.
   - They help manage changes, improvements, and compatibility over time, such as `0.1`, `0.2`, etc.

### Writing a Facets Terraform Module

A typical module in this repository follows a structured layout to organize its components effectively. Below is an example of the folder structure:

```
module_name/
│
├── facets.yaml
│   └── Defines the metadata and configuration for the module.
│
├── main.tf
│   └── Contains the primary Terraform configuration for the module.
│
├── variables.tf
│   └── Declares the input variables used by the module.
│
├── outputs.tf
│   └── Specifies the outputs that the module will produce.
│
├── README.md
│   └── Provides documentation and usage instructions for the module.
│
└── test/
    ├── main.tf
    │   └── Sets up the test environment for the module.
    └── test.json
        └── Provides test configurations for the module.
```

This structure helps maintain consistency across modules and ensures that all necessary components are included for module functionality and testing.

#### variables.tf

Facets modules can only accept a fixed set of variables. These variables are defined in the `variables.tf` file and include:

```hcl
variable "instance" {
  description = "The JSON representation of the resource in the Facets blueprint."
  type        = object({
    kind    = string   # Specifies the intent of the module, such as `mysql`, `s3`, etc.
    flavor  = string   # Indicates the specific implementation of the intent, such as `rds`, `standard`, etc.
    version = string   # Specifies the version of the flavor.
    spec    = any      # Contains the configuration details specific to the module. Schema of this will be described in `facets.yaml`
  })
}

variable "instance_name" {
  description = "The architectural name for the resource as added in the Facets blueprint designer."
  type        = string
}

variable "environment" {
  description = "An object containing details about the environment."
  type        = object({
    name        = string
    unique_name = string
  })
}

variable "inputs" {
  description = "A map of inputs requested by the module developer."
  type        = map(any)
}
```

#### main.tf

The `main.tf` file contains the core logic of the Terraform module. It is where the primary Terraform configuration is defined, utilizing the variables and resources necessary to achieve the module's intent.

#### outputs.tf

Outputs for `interfaces` and `attributes` are automatically created from `local.output_interfaces` and `local.output_attributes`, respectively. These outputs must not be explicitly defined in the code. Ensure these locals are defined even if they are empty to maintain consistency.

Example from the `s3` module:

```hcl
locals {
  output_interfaces = {}  # Define network interfaces if applicable
  output_attributes = {
    bucket_name = aws_s3_bucket.this.bucket
    arn         = aws_s3_bucket.this.arn
  }
}
```

These standardized outputs help ensure consistency across modules and facilitate integration with other components by providing a predictable structure for accessing key information.

#### facets.yaml

The `facets.yaml` file is used to define the metadata and configuration for a Terraform module, including its intent, flavor, version, supported clouds, and outputs. It also specifies the schema for inputs and provides a sample configuration.

```yaml
# facets.yaml

intent: <intent>
# Specifies the intent that the module implements, representing its primary capability.

flavor: <flavor>
# Represents a specific implementation of the intent, allowing for different approaches.

version: <version>
# Indicates the version of the flavor, helping manage compatibility and updates.

clouds:
  # List of supported cloud providers for the module.
  # Acceptable values are aws, gcp, azure, and kubernetes.

spec: 
  # JSON schema for var.instance.spec
  # Defines the expected structure and data types for the instance variable required by the module.

outputs:
  <output_name>:
    type: "@outputs/<output_type>"
    providers:
      - <provider_name>
  # Specifies the type associated with a specific Terraform output. The <output_name> can be the name of a specific Terraform output or the special keyword 'default' to indicate the entire module's output. The providers section lists the providers exposed by this output.

inputs:
  <desired input name>:
    type: "@outputs/<type>"
    providers:
      - <provider_name>
  # Specifies the type of input required by the module. This will make var.inputs.<desired input name> available for use in the module. The providers section lists the providers required by this module along with this input. For more details, see [exposing_providers.md](exposing_providers.md).

sample: 
  # Sample value for var.instance
  # Provides an example of how the instance variable should be structured according to the schema.
```

For more details on exposing and consuming providers, see [exposing_providers.md](exposing_providers.md).

While the `facets.yaml` does not directly define outputs, the Terraform module itself should produce outputs that conform to a common structure for the given intent. This ensures that modules implementing the same intent can be used interchangeably and integrate seamlessly with other components.

### Local Testing

Local testing involves executing the module from your development machine. This means that the Terraform state will be stored locally, and you will need to configure the provider settings appropriately. Use the `test` directory which includes a `test.tf` file and a `test.json` file. The `test.tf` file sets up the required providers and invokes the module, while `test.json` provides the `var.instance` configuration. Ensure that the required providers are configured correctly to run the tests successfully. Note that you must provide the standard variables (`instance`, `instance_name`, `environment`, and `inputs`) yourself in the wrapping `test.tf`.

#### Example `test.tf`

```hcl
provider "aws" {
  profile = "your-aws-profile"
  region  = "us-east-1"
}

module "example_module" {
  source = "../"

  instance      = jsondecode(file("${path.module}/test.json"))
  instance_name = "example-instance"
  environment = {
    name        = "development"
    unique_name = "dev_project"
  }
  inputs = {}
}
```

#### Example `test.json`

```json
{
  "kind": "example",
  "flavor": "example-flavor",
  "version": "1.0",
  "spec": {
    "acl": "private",
    "versioning": true
  }
}
```

### Module Publishing Workflow

- **Publish module as a preview**:
  - Before publishing the module, clean up the `.terraform` directory and the Terraform state file to avoid bloating the module size. This ensures that only necessary files are included in the module package.
  - To publish the module as a preview, allowing module developers to test it in testing projects, run the following command:
    ```bash
    curl -s https://facets-cloud.github.io/facets-schemas/scripts/module_register.sh | bash -s -- -c <control_plane_url> -u <username> -t <token> -p <module_dir_path>
    ```

- **Publishing the Module**:
  - To publish the module in preview and make it available to all projects, use the following command:
    ```bash
    curl -s https://facets-cloud.github.io/facets-schemas/scripts/module_publish.sh | bash -s -- -c <control_plane_url> -u <username> -t <token> -i <module_intent> -f <module_flavor> -v <module_version>
    ```

- **Enabling Preview Modules**:
  - Once the module is registered, it is available to test in projects where preview modules are allowed. To make preview modules available in a project, run the following command:
    ```bash
    curl -s https://facets-cloud.github.io/facets-schemas/scripts/allow_preview_modules.sh | bash -s -- -c <control_plane_url> -u <username> -t <token> -p <project_name> -a true
    ```

### Best Practices and Guidelines

- **CI Workflow**: The following CI workflow is recommended for managing the lifecycle of your Terraform modules. This workflow ensures that modules are thoroughly tested in preview environments before being merged into the main branch and published as stable versions.

  ```mermaid
  graph TD
      A[Push to Feature Branch] -->|Module Published as Preview| B[Test in Preview Projects]
      B --> C[Merge to Main Branch]
      C -->|Publish as Stable| D[Done!]
  ```

- **Constructing Resource Names**:
  - You don't need to manually specify names like `bucket_name` in your configuration. These can often be constructed using a combination of `instance_name` and `unique_name`. This approach helps maintain consistency and reduces the risk of naming conflicts.
  - Consider using a standardized naming convention that incorporates environment and project identifiers to ensure uniqueness and clarity across your resources.

- **Using Your Own Terraform Module**:
  - If you have an existing Terraform module that you want to integrate, consider writing a wrapper module. This wrapper will invoke your existing module and help classify the variables.
  - Identify which variables should be configured by the end user via `instance.spec` and which should come from `inputs`. This classification allows for seamless integration and flexibility.
  - This approach simplifies the process of plugging in existing modules and ensures that they can be easily consumed within the Facets platform.

- **Provider Instantiation**:
  - You do not need to instantiate providers within your module, as they are passed on from the platform. This simplifies module configuration and ensures that provider settings are consistent across different modules.

- **Exposing Configurability**:
  - Any configurability that needs to be exposed should be done via the `var.instance.spec`. Ensure that these configurations are well abstracted to provide a seamless experience for the end user.
