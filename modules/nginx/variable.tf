variable "environment" {
  description = "Environment name."
}

variable "container_ports" {
  type = object({
    internal = number
    external = number
  })
  description = "Ports mapping for the Docker container."
}