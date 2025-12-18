
variable "vpc_id" {
  type        = string
  description = "VPC ID to attach the security group"
  default = "vpc-0bb85bb9d8012483b"
}

variable "my_ip_cidr" {
  type        = string
  description = "Your IP in CIDR to allow SSH"
}

variable "allow_http_cidr" {
  type        = string
  description = "CIDR allowed to access port 8080 (e.g., 0.0.0.0/0)"
}