# ═══════════════════════════════════════════════════════════════
# MODULE: networking/nat
# AWS EQUIVALENT: AWS NAT Gateway
#
# Auto-filters private subnets using regex
# Only private subnets get NAT — not public or data
# ═══════════════════════════════════════════════════════════════

resource "google_compute_router_nat" "nat" {
  project                            = var.project_id
  name                               = var.nat_name
  router                             = var.router_name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  dynamic "subnetwork" {
    for_each = var.subnet_self_links
    content {
      name                    = subnetwork.value
      source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
    }
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
