# ═══════════════════════════════════════════════════════════════
# MODULE: networking/firewall
# AWS EQUIVALENT: Security Groups + NACLs
# ═══════════════════════════════════════════════════════════════

resource "google_compute_firewall" "allow_internal" {
  project     = var.project_id
  name        = "${var.name_prefix}-allow-internal"
  network     = var.vpc_name
  description = "Allow all traffic between VMs within VPC"
  priority    = 1000
  direction   = "INGRESS"
  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
  source_ranges = [var.vpc_cidr]
}

resource "google_compute_firewall" "allow_health_check" {
  project     = var.project_id
  name        = "${var.name_prefix}-allow-health-check"
  network     = var.vpc_name
  description = "Allow GCP Load Balancer health checks"
  priority    = 1000
  direction   = "INGRESS"
  allow { protocol = "tcp" }
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

resource "google_compute_firewall" "allow_ssh_iap" {
  project     = var.project_id
  name        = "${var.name_prefix}-allow-ssh-iap"
  network     = var.vpc_name
  description = "Allow SSH only via Google IAP - no public SSH!"
  priority    = 1000
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

resource "google_compute_firewall" "allow_http_https" {
  project     = var.project_id
  name        = "${var.name_prefix}-allow-http-https"
  network     = var.vpc_name
  description = "Allow HTTP/HTTPS from internet to tagged VMs"
  priority    = 1000
  direction   = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}

resource "google_compute_firewall" "deny_all_ingress" {
  project     = var.project_id
  name        = "${var.name_prefix}-deny-all-ingress"
  network     = var.vpc_name
  description = "Deny all other ingress - security default"
  priority    = 65534
  direction   = "INGRESS"
  deny { protocol = "all" }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "allow_all_egress" {
  project     = var.project_id
  name        = "${var.name_prefix}-allow-all-egress"
  network     = var.vpc_name
  description = "Allow all outbound traffic"
  priority    = 1000
  direction   = "EGRESS"
  allow { protocol = "all" }
  destination_ranges = ["0.0.0.0/0"]
}
