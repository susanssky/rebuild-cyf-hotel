provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cyf-hotel-devops-github-tfstate"
    key    = "week4-1-rds-module.tfstate"
    region = "eu-west-2"
  }
}

module "rds" {
  source = "./module"

  vpc_cidr         = var.vpc_cidr
  subnet_number    = var.subnet_number
  anyone_access_ip = var.anyone_access_ip

  database_username = var.database_username
  database_password = var.database_password

  week_prefix = var.week_prefix
}

output "secret_manager_arn" {
  value = module.rds.secret_manager_arn
}

output "ec2_sg_id" {
  value = module.rds.ec2_sg_id
}

