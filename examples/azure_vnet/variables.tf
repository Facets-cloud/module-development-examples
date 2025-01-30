variable "instance" {
  description = "The JSON representation of the resource in the facets blueprint."
  type = any
}

variable "instance_name" {
  description = "The architectural name for the resource as added in the facets blueprint designer."
  type        = string
}

variable "environment" {
  description = "Details about the environment."
  type = object({
    name                = string
    unique_name         = string
    location            = string
    resource_group_name = string
  })
}

variable "inputs" {
  description = "A map of inputs requested by the module developer."
  type        = map(any)
}
