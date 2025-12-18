
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "my_ip_cidr" {
  description = "Your IP in CIDR format to allow SSH (e.g., 203.0.113.10/32)"
  type        = string
}

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

variable "key_name" {
  description = "Name of an existing AWS key pair to SSH into EC2"
  type        = string
}


variable "ami_id" {
  description = "AMI ID to use for EC2 (approved in your org)"
  type        = string
}


variable "region" {
  default = "ap-south-1"
}

variable "subnet_id" {}
variable "security_group_id" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "key_name" {}
variable "ami_id" {}
