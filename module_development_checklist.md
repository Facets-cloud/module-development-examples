# Module Development Checklist

1. **Provider Configuration**
   - [ ] Ensure provider definitions are not included within modules. Providers should be configured at a higher level and passed to modules.

2. **Facets YAML Configuration**
   - [ ] Define the `intent`, `flavor`, and `version` in `facets.yaml`.
   - [ ] Specify `spec` with appropriate types and constraints (e.g., enums for regions and instance types).
   - [ ] Ensure the `sample` section is consistent with the `spec` schema.

3. **Variables and Inputs**
   - [ ] Use only the standard Facets variables in `variables.tf`:
     - `instance`
     - `instance_name`
     - `environment`
     - `inputs`
   - [ ] Verify that all fields in `var.instance.spec` used in the Terraform code are defined in the `spec` schema in `facets.yaml`.
   - [ ] Ensure that inputs expected from the user are defined in `var.instance.spec`.
   - [ ] Ensure that inputs derived from other resources in the blueprint are accessed through `var.inputs`.
   - [ ] Verify that the keys assumed within `var.inputs` match the keys defined in the `inputs:` section of `facets.yaml` to ensure consistency and correctness.
   - [ ] Ensure that the attributes used within an input (subobject within `var.inputs`) match the output structure of the module whose output is referenced, maintaining alignment between input expectations and output definitions.
   - [ ] Verify that provider block attributes are valid outputs of the module being developed. The names should be derived in the same way as if you were to access them directly via `module.mymodule.<output_name>`.

4. **Resource Configuration**
   - [ ] Use consistent naming conventions for resources, incorporating `instance_name` and `environment` details to ensure uniqueness and clarity.

5. **Outputs**
   - [ ] Use `locals` for `output_interfaces` and `output_attributes` in `outputs.tf`.
   - [ ] In `output_interfaces` and `output_attributes` objects, if any key is sensitive, add the attribute name to the `secrets` list within the same object to ensure proper handling of sensitive data.
   - [ ] Do not explicitly define outputs; rely on the locals for consistency.
