
# x‑ui Fields Documentation

The **x‑ui** extension properties are used in your JSON Schema (or YAML) to control how form fields and groups are rendered, validated, and populated dynamically. By adding these properties directly to your schema definitions, you can tailor the user interface to match your business logic and design requirements.

> **Note:** All **x‑ui** fields must be defined exactly as shown (including the `x‑ui-` prefix) to be recognized by the form builder.

---

## Table of Contents

1. [Field Ordering and Visibility](#field-ordering-and-visibility)
   - x‑ui‑order
   - x‑ui‑override‑disable
   - x‑ui‑visible‑if
2. [Dynamic Data Population](#dynamic-data-population)
   - x‑ui‑dynamic‑enum
   - x‑ui‑api‑source
3. [User Guidance and Validation](#user-guidance-and-validation)
   - x‑ui‑placeholder
   - x‑ui‑error‑message
4. [Specialized Input Rendering](#specialized-input-rendering)
   - x‑ui‑yaml‑editor
   - x‑ui‑command
   - x‑ui‑typeable
5. [Miscellaneous UI Behaviors](#miscellaneous-ui-behaviors)
   - x‑ui‑toggle
   - x‑ui‑disable‑tooltip
   - x‑ui‑output‑type
6. [Additional Fields for Resource Configuration](#additional-fields-for-resource-configuration)
   - x‑ui‑secret‑ref / x‑ui‑variable‑ref
   - x‑ui‑compare
   - x‑ui‑unique & x‑ui‑unique‑pattern‑error‑message
   - x‑ui‑no‑sort

---

## Field Ordering and Visibility

### x‑ui‑order

**Purpose:**  
Defines the order in which fields should appear in the UI.

**Usage Example:**

```yaml
x-ui-order:
  - restart_policy
  - enable_host_anti_affinity
  - runtime
  - release
  - init_containers
  - sidecars
  - cloud_permissions
```

**UI Behavior:**  
The form builder processes the fields in the order specified by this array. Fields that are skipped (e.g., due to overrides) are filtered out.

---

### x‑ui‑override‑disable

**Purpose:**  
Prevents a field from being modified by the user—even if overrides are allowed—by either disabling or hiding it.

**Usage Example:**

```yaml
restart_policy:
  type: string
  title: Restart Policy
  description: Restart Policy - Always, OnFailure, Never
  x-ui-override-disable: true
  enum:
    - Always
    - OnFailure
    - Never
```

**UI Behavior:**  
Fields marked with this property are rendered as disabled or are omitted entirely from the override interface to ensure the blueprinted value remains intact.

---

### x‑ui‑visible‑if

**Purpose:**  
Conditionally displays a field or group based on the value of another field.

**Usage Example:**

```yaml
readiness_timeout:
  type: integer
  title: Readiness Timeout
  default: 10
  minimum: 0
  maximum: 10000
  x-ui-placeholder: "Enter readiness timeout for the Pod"
  x-ui-error-message: "Value must be between 0 and 10000"
  x-ui-visible-if:
    field: spec.runtime.health_checks.readiness_check_type
    values: ["PortCheck", "HttpCheck", "ExecCheck"]
  description: Maximum time for readiness (in sec)
```

**UI Behavior:**  
The control only appears (and is enabled) when the field referenced in `visible-if` has one of the specified values.

---

## Dynamic Data Population

### x‑ui‑dynamic‑enum

**Purpose:**  
Populates select options dynamically based on a JSON path or pointer in the schema. Often used when the list of valid values is determined by another part of the configuration.

**Usage Example:**

```yaml
readiness_port:
  type: string
  title: Readiness Port
  description: Port for Health Checks.
  x-ui-placeholder: "Enter readiness port for the Pod"
  x-ui-error-message: "Value must be a number from 1-65535"
  x-ui-visible-if:
    field: spec.runtime.health_checks.readiness_check_type
    values: ["PortCheck", "HttpCheck"]
  x-ui-dynamic-enum: spec.runtime.ports.*.port
  x-ui-disable-tooltip: "No Ports Added"
```

**UI Behavior:**  
The UI looks up the path provided (with wildcard support) to extract available options. If no options are found, the control is disabled and a tooltip is shown.

---

### x‑ui‑api‑source

**Purpose:**  
Fetches options for a select control via an API call. This is useful when valid values need to be queried from an external service.

**Usage Example:**

```yaml
name:
  type: string
  title: Name
  description: Secret name.
  x-ui-typeable: true
  x-ui-api-source:
    endpoint: "/cc-ui/v1/dropdown/stack/{{stackName}}/resources-info"
    method: GET
    params:
      includeContent: false
    labelKey: resourceName
    valueKey: resourceName
    valueTemplate: "${kubernetes_secret.{{value}}.out.attributes.name}"
    filterConditions:
      - field: resourceType
        value: kubernetes_secret
```

**UI Behavior:**  
The UI initiates an API call to the specified endpoint, processes the response using the defined keys and templates, and populates the dropdown options. With **x‑ui‑typeable** enabled, users may also type custom values.

---

## User Guidance and Validation

### x‑ui‑placeholder

**Purpose:**  
Provides example text or guidance within an input field.

**Usage Example:**

```yaml
memory:
  type: string
  title: Memory
  description: Memory size for the container.
  pattern: "^([1-9]|[1-5][0-9]|6[0-4])Gi$|^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-3][0-9]{3}|64000)Mi$"
  x-ui-placeholder: "Enter Memory (e.g., 1Gi or 512Mi)"
```

**UI Behavior:**  
The placeholder text is displayed when the input is empty to suggest the expected format.

---

### x‑ui‑error‑message

**Purpose:**  
Specifies a custom error message for when user input fails validation (e.g., does not match a pattern).

**Usage Example:**

```yaml
memory:
  type: string
  title: Memory
  description: Memory size for the container.
  pattern: "^([1-9]|[1-5][0-9]|6[0-4])Gi$|^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-3][0-9]{3}|64000)Mi$"
  x-ui-placeholder: "Enter Memory (e.g., 1Gi or 512Mi)"
  x-ui-error-message: "Value must be in the format 1Gi to 64Gi or 1Mi to 64000Mi"
```

**UI Behavior:**  
If a user’s input does not match the defined pattern or fails another validation, the UI displays this custom error message.

---

## Specialized Input Rendering

### x‑ui‑yaml‑editor

**Purpose:**  
Renders a dedicated YAML editor for complex objects or maps. This is ideal for inputs where free-form YAML is more appropriate than standard text fields.

**Usage Example:**

```yaml
env:
  title: Environment Variables
  description: Map of environment variables passed to the container.
  type: object
  x-ui-yaml-editor: true
```

**UI Behavior:**  
A specialized YAML editor (such as one based on Monaco Editor) is displayed to allow for syntax highlighting and proper YAML formatting. On save, the YAML is parsed into a JSON object.

---

### x‑ui‑command

**Purpose:**  
Indicates that the field should be treated as a command input, often requiring multiline editing or special formatting.

**Usage Example:**

```yaml
command:
  type: array
  title: Command
  description: Command to run in the container.
  items:
    type: string
  x-ui-command: true
```

**UI Behavior:**  
A custom editor or multi-line text area is rendered to accommodate command syntax, and the UI may perform additional formatting or validation appropriate for commands.

---

### x‑ui‑typeable

**Purpose:**  
Enables a select control to accept both pre-defined values and custom typed input, offering “combo box” functionality.

**Usage Example:**

```yaml
name:
  type: string
  title: Name
  description: Secret name.
  x-ui-typeable: true
  x-ui-api-source:  # (as shown above)
    ...
```

**UI Behavior:**  
Users can choose an option from a dropdown or type in a custom value. The control validates the input against any rules defined in the schema.

---

## Miscellaneous UI Behaviors

### x‑ui‑toggle

**Purpose:**  
Marks a group (or sometimes a field) as collapsible. This allows the UI to render a toggle button for showing or hiding a section.

**Usage Example:**

```yaml
cloud_permissions:
  type: object
  title: Cloud Permissions
  description: Assign roles and access permissions.
  x-ui-toggle: true
  properties:
    aws:
      type: object
      title: AWS
      x-ui-toggle: true
      properties:
        enable_irsa:
          type: boolean
          title: Enable IRSA
          description: Grant fine-grained AWS permissions to Kubernetes workloads.
```

**UI Behavior:**  
A toggle (collapse/expand) control is rendered alongside the group title, allowing the user to hide or reveal the group’s contents.

---

### x‑ui‑disable‑tooltip

**Purpose:**  
Provides a tooltip message when a field is disabled—often because no valid options are available for selection.

**Usage Example:**

```yaml
readiness_port:
  type: string
  title: Readiness Port
  x-ui-dynamic-enum: spec.runtime.ports.*.port
  x-ui-disable-tooltip: "No Ports Added"
```

**UI Behavior:**  
When the control is disabled (e.g., because the dynamic lookup returns no options), hovering over it shows the tooltip message.

---

### x‑ui‑output‑type

**Purpose:**  
Marks a field as an “output” type. This property is used to alter the display or further processing (for example, formatting using special notation).

**Usage Example:**

```yaml
arn:
  type: string
  title: ARN
  x-ui-output-type: "iam_policy_arn"
  ...
```

**UI Behavior:**  
The UI may format or process output-type fields differently—using specific templates or logic to display them.

---

## Additional Fields for Resource Configuration

### x‑ui‑secret‑ref and x‑ui‑variable‑ref

**Purpose:**  
Indicate that a field references a secret or variable. They often trigger the UI to display a button for creating new secrets or variables.

**Usage Example:**

```yaml
apiKey:
  type: string
  title: API Key
  x-ui-secret-ref: true
```

**UI Behavior:**  
A “Create New Secret” or “Create New Variable” button is rendered next to the field, allowing users to navigate to the respective management interface.

---

### x‑ui‑compare

**Purpose:**  
Sets up a validation rule to compare the current field’s value against another field. Custom error messages can be specified if the comparison fails.

**Usage Example:**

```yaml
confirmPassword:
  type: string
  x-ui-compare:
    field: password
    comparator: equal
    x-ui-error-message: "Passwords do not match."
```

**UI Behavior:**  
A custom validator checks the field’s value against the referenced field and displays the provided error message if they do not match.

---

### x‑ui‑unique and x‑ui‑unique‑pattern‑error‑message

**Purpose:**  
Ensure that values within a set (e.g., keys in a map) are unique.

**Usage Example:**

```yaml
identifier:
  type: string
  x-ui-unique: true
  x-ui-unique-pattern-error-message: "Each key must be unique."
```

**UI Behavior:**  
The UI validates that each instance of the field is unique among its peers and displays the custom error message if a duplicate is detected.

---

### x‑ui‑no‑sort

**Purpose:**  
Prevents the UI from automatically sorting the options in a select control.

**Usage Example:**

```yaml
priority:
  type: string
  enum:
    - High
    - Medium
    - Low
  x-ui-no-sort: true
```

**UI Behavior:**  
The dropdown options appear in the exact order defined in the schema without any automatic sorting.

---

## Summary

This guide provides a quick reference for all the **x‑ui** extension properties used to build dynamic, user-friendly forms. In your JSON/YAML schemas, you can combine these properties to:

- **Control Layout and Order:** Use **x‑ui‑order**, **x‑ui‑toggle**, and **x‑ui‑override‑disable** to manage field display.
- **Populate Options Dynamically:** Use **x‑ui‑dynamic‑enum** and **x‑ui‑api‑source** for dynamic data.
- **Enhance User Experience:** Provide guidance with **x‑ui‑placeholder** and custom error messages with **x‑ui‑error‑message**.
- **Handle Special Inputs:** Render specialized editors with **x‑ui‑yaml‑editor** and **x‑ui‑command**.
- **Validate and Enforce Rules:** Use **x‑ui‑compare**, **x‑ui‑unique**, and **x‑ui‑no‑sort** to enforce consistency.

By following these guidelines, you can design robust configurations that drive dynamic interfaces and provide a seamless user experience.
