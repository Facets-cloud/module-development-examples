variable "instance" {
  description = "The JSON representation of the resource in the Facets blueprint."
  type = object({
    kind    = string
    flavor  = string
    version = string
    spec    = object({
      instance_count = number
      region         = string
      instance_count = number
      region         = string
      instance_type  = string
    })
  })
}

variable "instance_name" {
  description = "The architectural name for the resource as added in the Facets blueprint designer."
  type        = string
}

variable "environment" {
  description = "An object containing details about the environment."
  type = object({
    name        = string
    unique_name = string
  })
}

variable "inputs" {
  description = "A map of inputs requested by the module developer."
  type        = map(any)
}
