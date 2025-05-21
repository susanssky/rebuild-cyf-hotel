provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cyf-hotel-devops-github-tfstate"
    key    = "week4-3-s3.tfstate"
    region = "eu-west-2"
  }
}
