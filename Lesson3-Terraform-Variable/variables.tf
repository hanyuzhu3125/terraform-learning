variable "aws_access_key" {
  description = "AWS access key ID"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS secret access key"
  type        = string
  sensitive   = true          # `terraform plan` で平文反映を防止
}

variable "project_name" {
  description = "Prefix for all resource names"
  type        = string
  default     = "terraform-training-lesson3"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of an existing EC2 KeyPair to enable SSH access"
  type        = string
  default     = ""
}