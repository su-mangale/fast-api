# EC2 Outputs
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.app_server.private_ip
}

output "ssh_connection" {
  description = "SSH connection command"
  value       = "ssh -i ${var.key_pair_name}.pem ubuntu@${aws_instance.app_server.public_ip}"
}

output "application_url" {
  description = "URL to access the application"
  value       = "http://${aws_instance.app_server.public_ip}:8000"
}

output "application_docs" {
  description = "API documentation URL"
  value       = "http://${aws_instance.app_server.public_ip}:8000/docs"
}
