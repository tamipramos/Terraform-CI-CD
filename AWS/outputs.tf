output "instance_IP_BE" {
  description = "Backend Server Public IP"
  value       = aws_instance.BE_server.public_ip
}

output "instance_IP_FE" {
  description = "Frontend Server Public IP"
  value       = aws_instance.FE_server.public_ip
}
