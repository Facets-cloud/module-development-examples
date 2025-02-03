variable "instance" {
  description = "The JSON representation of the resource in the Facets blueprint."
  type = object({
    kind    = string
    flavor  = string
    version = string
    spec    = object({
      cpu                   = string
      memory                = string
      nodes                 = number
      version               = string
      custom_chart_values   = map(any)
      authentication_method = string
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

variable "kubernetes_namespace" {
  description = "The namespace in which to deploy Kafka."
  type        = string
  default     = "default"
}
