provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cyf-hotel-devops-github-tfstate"
    key    = "week4-2-ec2-module.tfstate"
    region = "eu-west-2"
  }
}

module "ec2" {
  source = "./module"

  subnet_number = var.subnet_number

  ec2_sg_id      = var.ec2_sg_id
  ec2_public_key = var.ec2_public_key

  secret_manager_arn = var.secret_manager_arn

  week_prefix = var.week_prefix
}

output "ec2_public_ip" {
  value = module.ec2.ec2_public_ip
}

