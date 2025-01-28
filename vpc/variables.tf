variable "instance" {
  description = "The JSON representation of the resource in the facets blueprint."
  type = object({
    kind = string
    flavor = string
    version = string
    spec = object({
      cidr = string
    })
  })
}
