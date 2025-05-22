output "public_ec2_public_ip" {
  description = "Public IP address of the EC2 instance in the public subnet"
  value       = aws_instance.public_ec2.public_ip
}

output "private_ec2_id" {
  description = "Instance ID of the private EC2 instance"
  value       = aws_instance.private_ec2.id
}
