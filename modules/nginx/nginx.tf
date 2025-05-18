resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = local.container_name

  ports {
    internal = var.container_ports.internal
    external = var.container_ports.external
  }
}