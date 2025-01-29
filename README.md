### Introduction

This repository is a comprehensive guide for writing, testing, and using facets Terraform modules. It introduces the principles of module development through various examples. The primary goal is to enable platform engineers to create reusable modules that developers can easily consume via the Facets Blueprint Designer UI. This empowers developers to construct custom architectures, while the Facets platform automates the generation of project-specific Infrastructure as Code (IaC) necessary to manage environments based on these blueprints.

**Note:** These modules are intended for instructive purposes only and should not be used for any practical application. They serve as examples to demonstrate the concepts and practices of module development.

### Overview

This repository contains multiple examples of facets Terraform modules, including `s3`, `ecs_cluster`, `ecs_service`, and `vpc`. Each module is located in its respective directory and demonstrates different capabilities and configurations.

| Example      | Description                                           | Constructs Users Can Learn From                  |
|--------------|-------------------------------------------------------|--------------------------------------------------|
| `s3`         | Simple module with `facets.yaml` describing user input| How to define user inputs in `facets.yaml`       |
| `ecs_service`| Uses outputs from other modules as inputs             | How to consume outputs from other modules        |
| `vpc`        | Publishes outputs for other modules to use            | How to define outputs for use by other modules   |
| `ecs_cluster`| Publishes outputs for other modules to use            | How to define outputs for use by other modules   |

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
     curl -s https://facets-cloud.github.io/facets-schemas/scripts/list-intents.sh | bash -s -- -c <CP_HOST> -u <USER> -t <TOKEN>
     ```

4. **Flavor**:
   - A flavor selects the specific implementation of an intent.
   - For example, if the intent is `mysql`, flavors might include `rds` or `aurora`.
   - Each flavor is backed by a Facets Terraform module. Flavors allow for different technologies or approaches to fulfill the same intent, providing flexibility in how the intent is realized.

5. **Version**:
   - Versions indicate the iteration or release of a flavor.
   - They help manage changes, improvements, and compatibility over time, such as `0.1`, `0.2`, etc.

### Folder Structure of a Typical Module

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

### `facets.yaml` Structure

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
  # Specifies the type associated with a specific Terraform output. The <output_name> can be the name of a specific Terraform output or the special keyword 'default' to indicate the entire module's output. This allows other modules to request inputs of a type that may be available from various outputs of various modules.

inputs:
  <desired input name>:
    type: "@outputs/<type>"
  # Specifies the type of input required by the module. This will make var.inputs.<desired input name> available for use in the module.

sample: 
  # Sample value for var.instance
  # Provides an example of how the instance variable should be structured according to the schema.
```

While the `facets.yaml` does not directly define outputs, the Terraform module itself should produce outputs that conform to a common structure for the given intent. This ensures that modules implementing the same intent can be used interchangeably and integrate seamlessly with other components.

## Terraform Variables

All variables should be defined in the `variables.tf` file. This includes:

- `instance`: (Required) The JSON representation of the resource in the facets blueprint. This is passed as an object and includes the following fields:
  - `kind`: Specifies the intent of the module, such as `mysql`, `s3`, etc.
  - `flavor`: Indicates the specific implementation of the intent, such as `rds`, `standard`, etc.
  - `version`: Specifies the version of the flavor.
  - `spec`: Contains the configuration details specific to the module. **The JSON schema for this `spec` object is defined in the `facets.yaml` file under the `spec` field. This schema describes only the `spec` part of `var.instance`, detailing the expected structure and data types for the configuration specifics.**
- `instance_name`: (Required) The architectural name for the resource as added in the facets blueprint designer. This is a string and does not need to match the resource name in the cloud. For example, `billing-db` could be the `instance_name` if there is a resource in the blueprint named `instance_name`.
- `environment`: (Required) An object containing details about the environment. It includes:
  - `name`: The facets environment name.
  - `unique_name`: A combination of the facets project name and the facets environment name, formatted as `<facets project name>_<facets environment name>`. This is often useful in creating actual cloud resource names in combination with the `instance_name`.
- `inputs`: (Required) A map of inputs requested by the module developer, where each key is an input name and the value is the output received from other resources in the blueprint. These inputs are defined in the `facets.yaml` and are passed into the module to facilitate integration with other modules.

## Terraform Outputs

Outputs for `interfaces` and `attributes` are automatically created from `local.output_interfaces` and `local.output_attributes`, respectively. These outputs must not be explicitly defined in the code. Ensure these locals are defined even if they are empty to maintain consistency.

These standardized outputs help ensure consistency across modules and facilitate integration with other components by providing a predictable structure for accessing key information.

## Module Publishing Workflow

- **Publish module as a preview**:
  - Before registering the module, clean up the `.terraform` directory and the Terraform state file to avoid bloating the module size. This ensures that only necessary files are included in the module package.
  - To register the module, run the following command:
    ```bash
    curl -s https://facets-cloud.github.io/facets-schemas/scripts/module_register.sh | bash -s -- -c <FACETS_CONTROL_PLANE_HOST> -u <USER> -t <TOKEN> -p <MODULE_DIR_PATH>
    ```

- **Publishing the Module**:
  - To publish the module in preview and make it available to all projects, use the following command:
    ```bash
    curl -s https://facets-cloud.github.io/facets-schemas/scripts/module_publish.sh | bash -s -- -c <control plane url> -u <username> -t <token> -i <module_intent> -f <module_flavor> -v <module_version>
    ```

- **Enabling Preview Modules**:
  - Once the module is registered, it is available to test in projects where preview modules are allowed. To make preview modules available in a project, run the following command:
    ```bash
    curl -s https://facets-cloud.github.io/facets-schemas/scripts/allow_preview_modules.sh | bash -s -- -c <control plane url> -u <username> -t <token> -p <project-name> -a true
    ```

## Best Practices and Guidelines

- **Constructing Resource Names**:
  - You don't need to manually specify names like `bucket_name` in your configuration. These can often be constructed using a combination of `instance_name` and `unique_name`. This approach helps maintain consistency and reduces the risk of naming conflicts.
  - Consider using a standardized naming convention that incorporates environment and project identifiers to ensure uniqueness and clarity across your resources.

- **Provider Instantiation**:
  - You do not need to instantiate providers within your module, as they are passed on from the platform. This simplifies module configuration and ensures that provider settings are consistent across different modules.

- **Exposing Configurability**:
  - Any configurability that needs to be exposed should be done via the `var.instance.spec`. Ensure that these configurations are well abstracted to provide a seamless experience for the end user.

- **Local Testing**:
  - To test the module locally, use the `test` directory which includes a `main.tf` file and a `test.json` file. The `main.tf` file sets up the required providers and invokes the module, while `test.json` provides the `var.instance` configuration.
  - Ensure that the required providers are configured correctly to run the tests successfully.

- **Module Registration**:
  - Before registering the module, clean up the `.terraform` directory and the Terraform state file to avoid bloating the module size. This ensures that only necessary files are included in the module package.
  - To register the module, run the following command:
    ```bash
    curl -s https://facets-cloud.github.io/facets-schemas/scripts/module_register.sh | bash -s -- -c <FACETS_CONTROL_PLANE_HOST> -u <USER> -t <TOKEN> -p <MODULE_DIR_PATH>
    ```

- **Enabling Preview Modules**:
  - Once the module is registered, it is available to test in projects where preview modules are allowed. To make preview modules available in a project, run the following command:
    ```bash
    curl -s https://facets-cloud.github.io/facets-schemas/scripts/allow_preview_modules.sh | bash -s -- -c <control plane url> -u <username> -t <token> -p <project-name> -a true
    ```
