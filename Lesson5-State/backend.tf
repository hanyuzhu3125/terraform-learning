#use AWS s3 for remote state
terraform {
  backend "s3" {
    bucket = "terraform-remote-state-bucket"
    key    = "terraform/remote-state"
    region = "ap-northeast-1"
  }
}