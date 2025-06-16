
provider "google" {
  project = local.project_id
  region  = local.region
}

terraform {
  backend "gcs" {
    bucket = "cloud-week6-cyf-hotel-tfstate"
    prefix = "week6-2-gke"
  }
}

module "gke" {
  source = "./module"

  project_id  = local.project_id
  region      = local.region
  week_prefix = local.week_prefix

  db_name          = var.db_name
  db_user          = var.db_user
  db_pass          = var.db_pass
  db_url           = var.db_url
  flux_prod_db_url = var.flux_prod_db_url
  argo_prod_db_url = var.argo_prod_db_url
  server_url       = var.server_url
}

locals {
  week_prefix = "cloud-week6"
  project_id  = "cloud-week6-cyf-hotel"
  region      = "us-east1"
}
