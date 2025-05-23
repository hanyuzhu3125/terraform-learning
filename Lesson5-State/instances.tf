resource "aws_instance" "public_ec2" {
  ami           = var.AMIS[var.aws_region]
  instance_type = "t2.micro"
  provisioner "local-exec" {
    command = "echo ${aws_instance.public_ec2.private_ip} >> private_ips.txt"
  }
}

output "ip" {
  value = aws_instance.public_ec2.public_ip
  description = "demo for output"
  sensitive   = true
}