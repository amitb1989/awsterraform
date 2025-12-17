
variable "subnet_id" {
  type        = string
  description = "Subnet ID for EC2"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for EC2"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "Existing AWS key pair name to SSH"
}

variable "associate_public_ip" {
  type        = bool
  description = "Associate a public IP (true for public subnet)"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Additional resource tags"
  default     = {}
}

variable "app_port" {
   type        = number
  description = "Application port"
  default     = 8080
}


variable "ami_id" {
  type        = string
  description = "AMI ID to use for the EC2 instance"
}