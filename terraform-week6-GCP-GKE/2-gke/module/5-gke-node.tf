
resource "google_container_node_pool" "primary" {
  name       = "${var.week_prefix}-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = 1 # per zone

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 30
    spot         = true

    service_account = google_service_account.gke_workload_identity.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    tags = ["${var.week_prefix}-node"]

  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

}
