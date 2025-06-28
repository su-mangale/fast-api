output "monitoring_server_ip" {
  description = "Public IP address of the monitoring server"
  value       = aws_instance.monitoring_server.public_ip
}

output "monitoring_server_dns" {
  description = "Public DNS name of the monitoring server"
  value       = aws_instance.monitoring_server.public_dns
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = "http://${aws_instance.monitoring_server.public_ip}:3000"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${aws_instance.monitoring_server.public_ip}:9090"
}

output "ssh_command" {
  description = "SSH command to connect to the monitoring server"
  value       = "ssh -i ~/.ssh/${var.key_pair_name}.pem ubuntu@${aws_instance.monitoring_server.public_ip}"
}
