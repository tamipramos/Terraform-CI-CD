output "FE_private_ip" {
  value = aws_instance.FE_server.private_ip
}

output "BE_private_ip" {
  value = aws_instance.BE_server.private_ip
}

output "instance_IP_FE" {
  value = aws_instance.FE_server.public_ip
}

output "instance_IP_BE" {
  value = aws_instance.BE_server.public_ip
}

output "private_key_openssh" {
  value     = tls_private_key.terraform.private_key_openssh
  sensitive = true
}

output "private_key" {
  value     = tls_private_key.terraform.private_key_pem
  sensitive = true
}
