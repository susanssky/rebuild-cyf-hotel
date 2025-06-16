resource "google_compute_firewall" "fw_allow_health_check" {
  name    = "fw-allow-health-check"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
  }

  direction     = "INGRESS"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["${var.week_prefix}-node"]
}
