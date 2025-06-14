
provider "google" {
  project = local.project_id
  region  = local.region
}


terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }

    argocd = {
      source = "argoproj-labs/argocd"
    }
  }
  backend "gcs" {
    bucket = "cloud-week6-cyf-hotel-tfstate"
    prefix = "week6-3-argo"
  }
}

provider "argocd" {
  server_addr = "${data.kubernetes_service.argocd_server.status[0].load_balancer[0].ingress[0].ip}:443"
  username    = "admin"
  password    = data.kubernetes_secret.argocd_initial_admin_secret.data["password"]
  insecure    = true
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
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

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}

data "kubernetes_secret" "argocd_initial_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}


data "google_client_config" "default" {}

data "google_client_config" "provider" {}

data "google_container_cluster" "primary" {
  name     = "${local.week_prefix}-cluster"
  location = local.region
  project  = local.project_id
}
