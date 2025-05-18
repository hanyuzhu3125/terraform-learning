terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }

  required_version = ">= 1.11.0"

  backend "local" {}
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}