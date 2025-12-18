
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "ec2" {
  source              = "./modules/ec2"
  subnet_id           = var.subnet_id
  security_group_id   = var.security_group_id
  instance_type       = var.instance_type
  key_name            = var.key_name
  associate_public_ip = true
  app_port            = 8080
  ami_id              = var.ami_id
  tags = {
    Project = "HelloWorld"
    Owner   = "Amit"
  }
}

