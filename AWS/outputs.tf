output "instance_IP_BE" {
  description = "Backend Server Public IP"
  value       = aws_instance.BE_server.private_ip
}

output "instance_IP_FE" {
  description = "Frontend Server Public IP"
  value       = aws_instance.FE_server.private_ip
}

output "application_endpoint" {
  value       = aws_lb.app.dns_name
  description = "Public entrypoint of the application"
}

