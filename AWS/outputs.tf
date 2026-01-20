output "FE_private_ip" {
  value = aws_instance.FE_server.private_ip
}

output "BE_private_ip" {
  value = aws_instance.BE_server.private_ip
}

output "FE_public_ip" {
  value = aws_instance.FE_server.public_ip
}

output "BE_public_ip" {
  value = aws_instance.BE_server.public_ip
}
