module "nginx" {
  source = "../../../modules/nginx"

  environment = var.environment
  container_ports = var.container_ports

  providers = {
    docker = docker
  }
}