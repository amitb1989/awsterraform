
variable "subnet_id" {}
variable "security_group_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "associate_public_ip" {
  default = true
}
variable "tags" {
   default = {}
}
variable "app_port" {
  default = 8080
}


variable "ami_id" {
  type        = string
  description = "AMI ID to use for the EC2 instance"
}