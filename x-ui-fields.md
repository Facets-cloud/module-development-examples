# x‑ui Fields: Quick Reference Guide

The **x‑ui** extension properties enrich your JSON Schema definitions so that dynamic forms can be rendered with custom behavior, validation, and presentation. You define these properties directly in your schema (or YAML) and the form builder processes them to tailor the UI.

> **Important:**  
> Always include the `x‑ui-` prefix exactly as shown to ensure the form builder recognizes the property.

---

## Table of Contents

1. [Field Ordering and Visibility](#1-field-ordering-and-visibility)
   - **x‑ui‑order**
   - **x‑ui‑override‑disable**
   - **x‑ui‑visible‑if**
   - **x‑ui‑skip**
   - **x‑ui‑overrides‑only**
2. [Dynamic Data Population](#2-dynamic-data-population)
   - **x‑ui‑dynamic‑enum**
   - **x‑ui‑api‑source**
3. [Data Extraction and Lookup](#3-data-extraction-and-lookup)
   - **x‑ui‑lookup‑regex**
4. [User Guidance and Validation](#4-user-guidance-and-validation)
   - **x‑ui‑placeholder**
   - **x‑ui‑error‑message**
5. [Specialized Input Rendering](#5-specialized-input-rendering)
   - **x‑ui‑yaml‑editor**
   - **x‑ui‑command**
   - **x‑ui‑typeable**
6. [Miscellaneous UI Behaviors](#6-miscellaneous-ui-behaviors)
   - **x‑ui‑toggle**
   - **x‑ui‑disable‑tooltip**
   - **x‑ui‑output‑type**
7. [Additional Fields for Resource Configuration](#7-additional-fields-for-resource-configuration)
   - **x‑ui‑secret‑ref / x‑ui‑variable‑ref**
   - **x‑ui‑compare**
   - **x‑ui‑unique & x‑ui‑unique‑pattern‑error‑message**
   - **x‑ui‑no‑sort**

---

## 1. Field Ordering and Visibility

### x‑ui‑order

- **Purpose:**  
  Specifies the order in which fields appear.

- **Usage Example:**
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

- **UI Behavior:**  
  Fields are rendered in the specified order. Fields omitted (e.g., due to being skipped) are filtered out.

---

### x‑ui‑override‑disable

- **Purpose:**  
  Prevents a field from being modified by the user—ensuring that a blueprinted or default value remains intact.

- **Usage Example:**
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

- **UI Behavior:**  
  Such fields are either rendered as disabled or omitted from override forms.

---

### x‑ui‑visible‑if

- **Purpose:**  
  Conditionally displays a field or group based on the value of another field.

- **Usage Example:**
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
  ```

- **UI Behavior:**  
  The control is displayed only when the referenced field has one of the specified values.

---

### x‑ui‑skip

- **Purpose:**  
  Excludes a field from being rendered in the UI. Use this when you want to store data without displaying it to the user.

- **Usage Example:**
  ```yaml
  secretToken:
    type: string
    x-ui-skip: true
  ```

- **UI Behavior:**  
  The form builder ignores any property with **x‑ui‑skip**, so no control is generated for it.

---

### x‑ui‑overrides‑only

- **Purpose:**  
  Indicates that a field should only be available as an override (for example, in an override form) and not be part of the base configuration.

- **Usage Example:**
  ```yaml
  specialSetting:
    type: string
    default: "defaultValue"
    x-ui-overrides-only: true
  ```

- **UI Behavior:**  
  When the form is built, fields with **x‑ui‑overrides‑only** are included only in contexts where overrides are being applied.

---

## 2. Dynamic Data Population

### x‑ui‑dynamic‑enum

- **Purpose:**  
  Populates a select control’s options dynamically based on a JSON pointer or path.

- **Usage Example:**
  ```yaml
  readiness_port:
    type: string
    title: Readiness Port
    x-ui-dynamic-enum: spec.runtime.ports.*.port
    x-ui-disable-tooltip: "No Ports Added"
  ```

- **UI Behavior:**  
  The UI extracts available options from the defined path. If no options exist, the control is disabled with a tooltip.

---

### x‑ui‑api‑source

- **Purpose:**  
  Configures the control to fetch options via an API call.

- **Usage Example:**
  ```yaml
  name:
    type: string
    title: Name
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

- **UI Behavior:**  
  An API call is made to populate options; the returned data is processed using defined keys and templates. With **x‑ui‑typeable**, users can also input custom values.

---

## 3. Data Extraction and Lookup

### x‑ui‑lookup‑regex

- **Purpose:**  
  Applies a regular expression to a field’s value to extract a substring for dynamic processing.  
  (For instance, you might need to strip a prefix from a value.)

- **Usage Example:**
  ```yaml
  identifier:
    type: string
    lookup: regex
    x-ui-lookup-regex: '^prefix-(.*)$'
  ```

- **UI Behavior:**  
  If the field’s `lookup` type is set to `"regex"`, the UI applies the regular expression from **x‑ui‑lookup‑regex** to the input value and extracts the first capturing group. This extracted value may be used to dynamically construct URLs or set dynamic properties.

---

## 4. User Guidance and Validation

### x‑ui‑placeholder

- **Purpose:**  
  Provides in-field example text to guide the user.

- **Usage Example:**
  ```yaml
  memory:
    type: string
    title: Memory
    x-ui-placeholder: "Enter Memory (e.g., 1Gi or 512Mi)"
  ```

- **UI Behavior:**  
  The placeholder text appears in empty input fields.

---

### x‑ui‑error‑message

- **Purpose:**  
  Displays a custom error message when validation (such as a pattern check) fails.

- **Usage Example:**
  ```yaml
  memory:
    type: string
    title: Memory
    pattern: "^([1-9]|[1-5][0-9]|6[0-4])Gi$|^([1-9][0-9]{0,3}|[1-5][0-9]{4}|6[0-3][0-9]{3}|64000)Mi$"
    x-ui-placeholder: "Enter Memory (e.g., 1Gi or 512Mi)"
    x-ui-error-message: "Value must be in the format 1Gi to 64Gi or 1Mi to 64000Mi"
  ```

- **UI Behavior:**  
  When the user’s input fails validation, this message is shown.

---

## 5. Specialized Input Rendering

### x‑ui‑yaml‑editor

- **Purpose:**  
  Renders a dedicated YAML editor for complex or large objects.

- **Usage Example:**
  ```yaml
  env:
    title: Environment Variables
    type: object
    x-ui-yaml-editor: true
  ```

- **UI Behavior:**  
  A specialized editor (often with syntax highlighting) is displayed, and the YAML is parsed to JSON when saved.

---

### x‑ui‑command

- **Purpose:**  
  Indicates that the field should be treated as a command input, often needing a multi-line editor.

- **Usage Example:**
  ```yaml
  command:
    type: array
    title: Command
    items:
      type: string
    x-ui-command: true
  ```

- **UI Behavior:**  
  A multiline or code editor is rendered to facilitate command entry.

---

### x‑ui‑typeable

- **Purpose:**  
  Allows users to both select from a list and type a custom value.

- **Usage Example:**
  ```yaml
  name:
    type: string
    title: Name
    x-ui-typeable: true
  ```

- **UI Behavior:**  
  The dropdown control accepts custom input as well as selections from the provided options.

---

## 6. Miscellaneous UI Behaviors

### x‑ui‑toggle

- **Purpose:**  
  Renders a collapsible group of fields.

- **Usage Example:**
  ```yaml
  cloud_permissions:
    type: object
    title: Cloud Permissions
    x-ui-toggle: true
    properties:
      aws:
        type: object
        title: AWS
        x-ui-toggle: true
  ```

- **UI Behavior:**  
  Toggle buttons allow the user to expand or collapse the group.

---

### x‑ui‑disable‑tooltip

- **Purpose:**  
  Shows a tooltip when a control is disabled, explaining why no valid options are available.

- **Usage Example:**
  ```yaml
  readiness_port:
    type: string
    title: Readiness Port
    x-ui-dynamic-enum: spec.runtime.ports.*.port
    x-ui-disable-tooltip: "No Ports Added"
  ```

- **UI Behavior:**  
  When disabled, the tooltip appears on hover.

---

### x‑ui‑output‑type

- **Purpose:**  
  Flags a field as an output type, which might affect its display or processing.

- **Usage Example:**
  ```yaml
  arn:
    type: string
    title: ARN
    x-ui-output-type: "iam_policy_arn"
  ```

- **UI Behavior:**  
  The field might be formatted or handled differently in the UI based on its output type.

---

## 7. Additional Fields for Resource Configuration

### x‑ui‑secret‑ref and x‑ui‑variable‑ref

- **Purpose:**  
  Identify fields that reference external secrets or variables, and prompt the UI to provide options to create new ones.

- **Usage Example:**
  ```yaml
  apiKey:
    type: string
    title: API Key
    x-ui-secret-ref: true
  ```

- **UI Behavior:**  
  A “Create New Secret” or “Create New Variable” button is rendered next to the field.

---

### x‑ui‑compare

- **Purpose:**  
  Sets up a comparison validation between two fields.

- **Usage Example:**
  ```yaml
  confirmPassword:
    type: string
    x-ui-compare:
      field: password
      comparator: equal
      x-ui-error-message: "Passwords do not match."
  ```

- **UI Behavior:**  
  A custom validator checks the value against the referenced field and displays the error message if needed.

---

### x‑ui‑unique & x‑ui‑unique‑pattern‑error‑message

- **Purpose:**  
  Ensures that values (such as keys in a map) are unique.

- **Usage Example:**
  ```yaml
  identifier:
    type: string
    x-ui-unique: true
    x-ui-unique-pattern-error-message: "Each key must be unique."
  ```

- **UI Behavior:**  
  The UI validates uniqueness and shows the custom error if a duplicate is detected.

---

### x‑ui‑no‑sort

- **Purpose:**  
  Prevents automatic sorting of select options, preserving the order defined in the schema.

- **Usage Example:**
  ```yaml
  priority:
    type: string
    enum:
      - High
      - Medium
      - Low
    x-ui-no-sort: true
  ```

- **UI Behavior:**  
  Options are rendered in the exact order provided.

---

## Summary

This comprehensive guide covers all the **x‑ui** extension properties—including the newly added **x‑ui‑skip**, **x‑ui‑lookup‑regex**, and **x‑ui‑overrides‑only**—and explains how they control the dynamic behavior and presentation of forms:

- **Ordering & Visibility:**  
  Use **x‑ui‑order**, **x‑ui‑override‑disable**, **x‑ui‑visible‑if**, **x‑ui‑skip**, and **x‑ui‑overrides‑only** to determine which fields are shown, in what order, and in which contexts (e.g., overrides only).

- **Dynamic Data:**  
  **x‑ui‑dynamic‑enum** and **x‑ui‑api‑source** help populate fields based on other parts of the configuration or external API calls.

- **Data Extraction:**  
  **x‑ui‑lookup‑regex** enables you to extract portions of a field’s value for dynamic processing.

- **User Guidance & Validation:**  
  **x‑ui‑placeholder** and **x‑ui‑error‑message** provide in-field guidance and custom validation feedback.

- **Specialized Rendering:**  
  **x‑ui‑yaml‑editor**, **x‑ui‑command**, and **x‑ui‑typeable** customize how input is received for complex data.

- **Additional Behaviors:**  
  **x‑ui‑toggle**, **x‑ui‑disable‑tooltip**, **x‑ui‑output‑type**, **x‑ui‑secret‑ref**, **x‑ui‑compare**, **x‑ui‑unique**, and **x‑ui‑no‑sort** offer further control over layout, interactivity, and data integrity.

By following this guide, end users and schema authors can quickly reference and apply **x‑ui** properties to create dynamic, robust, and user-friendly forms for configuring services and resources.

