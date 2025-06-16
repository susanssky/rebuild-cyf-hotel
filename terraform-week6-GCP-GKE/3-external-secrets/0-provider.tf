

provider "google" {
  project = local.project_id
  region  = local.region
}

terraform {
  backend "gcs" {
    bucket = "cloud-week6-cyf-hotel-tfstate"
    prefix = "week6-3-external-secrets"
  }
}

provider "helm" {
  kubernetes {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.provider.access_token
    client_certificate     = base64decode(data.google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(data.google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}



data "google_client_config" "default" {}

data "google_client_config" "provider" {}

data "google_container_cluster" "primary" {
  name     = "${local.week_prefix}-cluster"
  location = local.region
  project  = local.project_id
}


data "google_service_account" "gke_workload_identity" {
  account_id = "gke-workload-identity"
}

