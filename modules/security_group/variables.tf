
variable "vpc_id" {
  type        = string
  description = "VPC ID to attach the security group"
  default = "vpc-06f9bfdbebd7beaec"
}

variable "my_ip_cidr" {
  type        = string
  description = "Your IP in CIDR to allow SSH"
  default = "172.31.0.0/16"
}

variable "allow_http_cidr" {
  type        = string
  description = "CIDR allowed to access port 8080 (e.g., 0.0.0.0/0)"
}