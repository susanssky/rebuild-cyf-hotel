resource "google_compute_network" "vpc" {
  name                    = "${var.week_prefix}-vpc"
  auto_create_subnetworks = false

  depends_on = [google_project_service.container]
}