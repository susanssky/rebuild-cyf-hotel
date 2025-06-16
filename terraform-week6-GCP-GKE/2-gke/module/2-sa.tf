
resource "google_service_account" "gke_workload_identity" {
  account_id = "gke-workload-identity"
  project    = var.project_id
}


resource "google_project_iam_member" "gke_secret_accessor" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.gke_workload_identity.email}"
}

resource "time_sleep" "wait_for_workload_identity" {
  depends_on      = [google_container_cluster.primary]
  create_duration = "120s"
}


resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.gke_workload_identity.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[default/${google_service_account.gke_workload_identity.account_id}]",          # default
    "serviceAccount:${var.project_id}.svc.id.goog[external-secrets/${google_service_account.gke_workload_identity.account_id}]", # External Secrets Operator

    # remove because of ClusterSecretStore
    # "serviceAccount:${var.project_id}.svc.id.goog[argo-prod/${google_service_account.gke_workload_identity.account_id}]", # ArgoCD prod
    # "serviceAccount:${var.project_id}.svc.id.goog[flux-prod/${google_service_account.gke_workload_identity.account_id}]"  # FluxCD prod
  ]
  depends_on = [time_sleep.wait_for_workload_identity]
}

