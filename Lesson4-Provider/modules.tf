data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  tags = {
    Project = var.project_name
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.project_name
  cluster_version = var.cluster_version

  subnet_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)
  vpc_id     = module.vpc.vpc_id

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.cluster_endpoint_public_access_cidrs
  cluster_endpoint_private_access      = true

  eks_managed_node_groups = {
    default = {
      subnet_ids     = module.vpc.private_subnets
      instance_types = [var.node_instance_type]
      desired_size   = var.desired_size
      max_size       = var.max_size
      min_size       = var.min_size
    }
  }

  enable_irsa = true

  tags = {
    Project = var.project_name
  }
}