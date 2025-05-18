variable "environment" {
  default = "test"
}

variable "container_ports" {
  default = {
    internal = 80
    external = 8001
  }
}