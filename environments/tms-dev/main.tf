# ═══════════════════════════════════════════════════════════════
# ENVIRONMENT: tms-dev (SERVICE PROJECT)
#
# PURPOSE:
# Deploys TMS DEV application resources into the
# Shared VPC managed by host-dev-project.
#
# IMPORTANT:
# This environment does NOT create VPC or subnets!
# Those are created by environments/host-dev
# This project USES the shared subnets from host-dev
#
# WHAT THIS CREATES:
# 1. Cloud SQL (PostgreSQL 16) — in host-dev VPC
# 2. DB Password → Secret Manager
# 3. PSA for Cloud SQL private IP
#
# RUN AFTER: environments/host-dev
# ═══════════════════════════════════════════════════════════════

# ── 1. PSA for Cloud SQL private IP ──────────────────────────
# Cloud SQL needs Private Service Access to get private IP
# in the shared VPC
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "tms-dev-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.host_vpc_id
  project       = var.host_project_id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = var.host_vpc_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}

# ── 2. Cloud SQL ──────────────────────────────────────────────
# Created in tms-dev project but uses host-dev VPC
# Matches AWS dev-services-db (db.t4g.large = db-custom-2-8192)
module "db" {
  source                = "../../modules/database/cloud-sql"
  project_id            = var.project_id
  region                = var.region
  instance_name         = "tms-dev-db"
  vpc_id                = var.host_vpc_id
  db_peering_connection = google_service_networking_connection.private_vpc_connection.id
  db_username           = "postgres"
  db_name               = "dev-services-db"
}

# ── 3. Secret Manager ─────────────────────────────────────────
# Stores DB password in tms-dev project's Secret Manager
module "db_secret" {
  source       = "../../modules/security/secret-manager"
  project_id   = var.project_id
  secret_name  = "tms-dev-db-password"
  secret_value = module.db.db_password

  labels = {
    environment = "dev"
    service     = "tms"
    managed_by  = "terraform"
  }

  depends_on = [module.db]
}
