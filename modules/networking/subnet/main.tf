# ═══════════════════════════════════════════════════════════════
# MODULE: networking/subnet
# AWS EQUIVALENT: AWS Subnet (but GCP subnets are regional!)
#
# KEY DIFFERENCE FROM AWS:
# GCP subnets are REGIONAL — one subnet spans ALL zones
# in a region. You do NOT create per-AZ subnets like AWS.
#
# GKE SECONDARY RANGES:
# GKE requires secondary IP ranges attached to private subnets:
# → pods range    : IP addresses for GKE pods
# → services range: IP addresses for GKE ClusterIP services
#
# SHARED VPC NOTE:
# Subnets are created in HOST project
# Service projects use them via Shared VPC IAM
# ═══════════════════════════════════════════════════════════════

resource "google_compute_subnetwork" "subnet" {
  for_each = var.subnets

  name                     = each.key
  ip_cidr_range            = each.value.cidr
  region                   = var.region
  network                  = var.vpc_self_link
  project                  = var.project_id
  description              = lookup(each.value, "description", "")
  private_ip_google_access = lookup(each.value, "private_ip_google_access", false)

  # GKE secondary ranges — only on private subnets
  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ranges", [])
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  # VPC Flow Logs — 10% sampling for dev, 50% staging, 100% prod
  log_config {
    aggregation_interval = "INTERVAL_5_MIN"
    flow_sampling        = var.flow_sampling
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
