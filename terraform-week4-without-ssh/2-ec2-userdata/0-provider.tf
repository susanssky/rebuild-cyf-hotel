provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cyf-hotel-devops-github-tfstate"
    key    = "week4-2-ec2-userdata.tfstate"
    region = "eu-west-2"
  }
}
