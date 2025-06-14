locals {
  secrets = {
    "db-name"          = var.db_name,
    "db-user"          = var.db_user,
    "db-pass"          = var.db_pass,
    "db-url"           = var.db_url,
    "flux-prod-db-url" = var.flux_prod_db_url,
    "argo-prod-db-url" = var.argo_prod_db_url,
    "server-url"       = var.server_url,
  }
}


resource "google_secret_manager_secret" "secrets" {
  for_each = local.secrets

  secret_id = each.key
  replication {
    auto {}
  }
}


resource "google_secret_manager_secret_version" "secret_versions" {
  for_each = local.secrets

  secret         = google_secret_manager_secret.secrets[each.key].id
  secret_data_wo = each.value
}
