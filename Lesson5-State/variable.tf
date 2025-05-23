variable "aws_region" {
  default = "ap-northeast-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    ap-northeast-2 = "ami-0c1638aa346a43fe8"
  }
}