

provider "google" {
  project = local.project_id
  region  = local.region
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
}


data "google_client_config" "default" {}


data "google_container_cluster" "primary" {
  name     = "${local.week_prefix}-cluster"
  location = local.region
  project  = local.project_id
}

