
output "public_ip" {
  value = aws_instance.this.public_ip
}

output "app_port" {
  value = var.app_port
}