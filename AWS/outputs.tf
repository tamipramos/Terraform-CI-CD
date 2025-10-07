output "instance_hostname_BE" {
  description = "Backend Server Public DNS"
  value       = aws_instance.BE_server.public_dns
}

output "instance_hostname_FE" {
  description = "Frontend Server Public DNS"
  value       = aws_instance.FE_server.public_dns
}