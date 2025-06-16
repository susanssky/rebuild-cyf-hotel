provider "google" {
  project = local.project_id
  region  = local.region
}


terraform {
  required_providers {
    flux = {
      source = "fluxcd/flux"
    }
    github = {
      source = "integrations/github"
    }

  }
  backend "gcs" {
    bucket = "cloud-week6-cyf-hotel-tfstate"
    prefix = "week6-3-flux"
  }
}



provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}


provider "flux" {
  kubernetes = {
    host                   = "https://${data.google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.provider.access_token
    client_certificate     = base64decode(data.google_container_cluster.primary.master_auth.0.client_certificate)
    client_key             = base64decode(data.google_container_cluster.primary.master_auth.0.client_key)
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
  git = {
    url = "https://github.com/${local.repo_owner}/${local.flux_repo_name}.git"
    http = {
      username = "git"
      password = var.github_token
    }
  }
}

provider "github" {
  token = var.github_token
}



data "google_client_config" "default" {}

data "google_client_config" "provider" {}

data "google_container_cluster" "primary" {
  name     = "${local.week_prefix}-cluster"
  location = local.region
  project  = local.project_id
}