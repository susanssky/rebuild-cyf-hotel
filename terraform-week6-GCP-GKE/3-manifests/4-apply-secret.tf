locals {
  secrets = [
    "db-name",
    "db-user",
    "db-pass",
    "db-url",
    "server-url"
  ]
  manifest_path = "../../manifest-k8s"
}

data "google_secret_manager_secret" "secrets" {
  for_each  = toset(local.secrets)
  secret_id = each.key
}

data "google_secret_manager_secret_version" "secrets" {
  for_each = toset(local.secrets)
  secret   = data.google_secret_manager_secret.secrets[each.key].secret_id
  version  = "latest"
}

resource "kubernetes_manifest" "sa" {
  manifest = yamldecode(file("${local.manifest_path}/service-account.yaml"))
}


resource "kubernetes_secret" "database_secrets" {
  metadata {
    name = "database-secrets"
  }
  data = {
    db_name = data.google_secret_manager_secret_version.secrets["db-name"].secret_data
    db_user = data.google_secret_manager_secret_version.secrets["db-user"].secret_data
    db_pass = data.google_secret_manager_secret_version.secrets["db-pass"].secret_data
  }
}

resource "kubernetes_secret" "backend_secrets" {
  metadata {
    name = "backend-secrets"
  }
  data = {
    db_url = data.google_secret_manager_secret_version.secrets["db-url"].secret_data
  }
}

resource "kubernetes_secret" "frontend_secrets" {
  metadata {
    name = "frontend-secrets"
  }
  data = {
    server_url = data.google_secret_manager_secret_version.secrets["server-url"].secret_data
  }
}
