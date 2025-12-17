
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

# 1) Network (VPC + Public Subnet + IGW + Route Table)
module "network" {
  source               = "./modules/network"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# 2) Security Group (SSH + HTTP 8080)
module "sg" {
  source     = "./modules/security_group"
  vpc_id     = module.network.vpc_id
  my_ip_cidr = var.my_ip_cidr
  allow_http_cidr = var.allow_http_cidr
}

# 3) EC2 instance with Java HelloWorld
module "ec2" {
  source                 = "./modules/ec2"
  subnet_id              = module.network.public_subnet_id
  security_group_id      = module.sg.sg_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  associate_public_ip    = true
  app_port               = 8080
  tags                   = {
    Project = "HelloWorld"
    Owner   = "Dilipbhai"
  }
}
