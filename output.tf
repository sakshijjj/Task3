output "WebClues_ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.WebClues-ec2.public_ip
}
