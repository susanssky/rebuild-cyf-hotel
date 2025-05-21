provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cyf-hotel-devops-github-tfstate"
    key    = "week4-1-rds.tfstate"
    region = "eu-west-2"
  }
}
