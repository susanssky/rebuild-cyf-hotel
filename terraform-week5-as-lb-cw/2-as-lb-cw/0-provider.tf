provider "aws" {}

terraform {
  backend "s3" {
    bucket = "cyf-devops-github-tfstate"
    key    = "week5-2-as-lb-cw.tfstate"
    region = "eu-west-2"
  }
}
