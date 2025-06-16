resource "google_compute_router" "router" {
  name    = "${var.week_prefix}-router"
  network = google_compute_network.vpc.name

  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  name   = "${var.week_prefix}-nat"
  router = google_compute_router.router.name
  region = var.region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.subnet.name
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

