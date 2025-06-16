resource "google_container_cluster" "primary" {
  name       = "${var.week_prefix}-cluster"
  location   = var.region
  network    =  "${var.week_prefix}-vpc"
  subnetwork =  "${var.week_prefix}-subnet"

  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # Enable private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }


  release_channel {
    channel = "STABLE"
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # depends_on = [google_project_service.container_api]
  deletion_protection = false
}
