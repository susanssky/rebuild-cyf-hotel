provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cyf-devops-github-tfstate"
    key    = "week4-2-s3.tfstate"
    region = "eu-west-2"
  }
}
