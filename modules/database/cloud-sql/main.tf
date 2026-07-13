# ═══════════════════════════════════════════════════════════════
# MODULE: database/cloud-sql
# AWS EQUIVALENT: AWS RDS PostgreSQL
#
# PURPOSE:
# Creates Cloud SQL instance + database + user only.
# Password is generated here and passed to
# modules/security/secret-manager/ for storage.
#
# SEPARATION OF CONCERNS:
# cloud-sql/       → database resources only
# secret-manager/  → secret storage only
# ═══════════════════════════════════════════════════════════════

resource "google_sql_database_instance" "instance" {
  name                = var.instance_name
  project             = var.project_id
  region              = var.region
  database_version    = var.database_version
  deletion_protection = true
  depends_on          = [var.db_peering_connection]

  settings {
    tier    = "db-custom-2-8192"
    edition = "ENTERPRISE"

    ip_configuration {
      ipv4_enabled                                  = false
      private_network                               = var.vpc_id
      enable_private_path_for_google_cloud_services = true
    }

    availability_type     = "ZONAL"
    disk_type             = "PD_SSD"
    disk_size             = 200
    disk_autoresize       = true
    disk_autoresize_limit = 1000

    backup_configuration {
      enabled                        = true
      start_time                     = "02:00"
      point_in_time_recovery_enabled = true
    }
  }
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.instance.name
  project  = var.project_id
}

# Generate password here — pass to secret-manager module
resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "google_sql_user" "db_user" {
  name     = var.db_username
  instance = google_sql_database_instance.instance.name
  password = random_password.db_password.result
  project  = var.project_id
}
