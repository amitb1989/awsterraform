
output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "Public IP address of the EC2 instance"
}

output "helloworld_url" {
  value       = "http://${module.ec2.public_ip}:${module.ec2.app_port}/"
  description = "URL to reach the HelloWorld Java app"
}
