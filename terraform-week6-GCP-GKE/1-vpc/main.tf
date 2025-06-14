provider "google" {
  project = local.project_id
  region  = local.region
}

terraform {
  backend "gcs" {
    bucket = "cloud-week6-cyf-hotel-tfstate"
    prefix = "week6-1-vpc"
  }
}

locals {
  week_prefix = "cloud-week6"
  project_id  = "cloud-week6-cyf-hotel"
  region      = "us-east1"
}

module "vpc" {
  source = "./module"

  region      = local.region
  week_prefix = local.week_prefix
}
