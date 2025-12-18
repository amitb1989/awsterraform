variable "allow_http_cidr" {
  description = "CIDR range allowed to access HTTP port 8080"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}


variable "region" {
  default = "us-east-1"
}

variable "subnet_id" {}
variable "security_group_id" {}
variable "key_name" {}
variable "ami_id" {}
