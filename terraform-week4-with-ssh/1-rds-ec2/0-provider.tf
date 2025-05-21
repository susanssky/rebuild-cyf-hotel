provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cyf-devops-github-tfstate"
    key    = "week4-1-rds-ec2.tfstate"
    region = "eu-west-2"
  }
}
