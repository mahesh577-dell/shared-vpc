# ═══════════════════════════════════════════════════════════════
# BOOTSTRAP — Parameterized Per-Project Setup
#
# WHAT THIS DOES (for ONE project at a time):
# 1. Enables required APIs based on project type
# 2. Creates state bucket IN the project
# 3. Creates a DEDICATED CircleCI SA for the project
#    → Individual SA per project = least privilege
#    → Key leaked = only 1 project at risk
#
# HOW TO USE:
# ./run_bootstrap.sh tms-dev
#   OR
# terraform apply \
#   -state="states/tms-dev.tfstate" \
#   -var-file="projects/tms-dev.tfvars"
#   OR via CircleCI:
# Trigger Pipeline → run_bootstrap=true, bootstrap_env=tms-dev
# ═══════════════════════════════════════════════════════════════

locals {
  # APIs by project type
  api_sets = {
    host = [
      "compute.googleapis.com",
      "container.googleapis.com",
      "servicenetworking.googleapis.com",
      "iam.googleapis.com",
      "logging.googleapis.com",
      "monitoring.googleapis.com",
      "storage.googleapis.com",
      "cloudresourcemanager.googleapis.com",
    ]
    service = [
      "compute.googleapis.com",
      "container.googleapis.com",
      "sqladmin.googleapis.com",
      "secretmanager.googleapis.com",
      "artifactregistry.googleapis.com",
      "servicenetworking.googleapis.com",
      "iam.googleapis.com",
      "logging.googleapis.com",
      "monitoring.googleapis.com",
      "storage.googleapis.com",
      "cloudresourcemanager.googleapis.com",
    ]
    analytics = [
      "compute.googleapis.com",
      "dataflow.googleapis.com",
      "bigquery.googleapis.com",
      "pubsub.googleapis.com",
      "datastream.googleapis.com",
      "iam.googleapis.com",
      "logging.googleapis.com",
      "monitoring.googleapis.com",
      "storage.googleapis.com",
      "cloudresourcemanager.googleapis.com",
    ]
  }

  apis = local.api_sets[var.project_type]
}

# ── 1. Enable APIs for this project ───────────────────────────
resource "google_project_service" "apis" {
  for_each = toset(local.apis)

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false
}

# ── 2. Create State Bucket IN this project ────────────────────
resource "google_storage_bucket" "tfstate" {
  project                     = var.project_id
  name                        = "freightfox-tfstate-${var.env_name}"
  location                    = var.region
  uniform_bucket_level_access = true
  force_destroy               = false

  versioning {
    enabled = true
  }

  labels = {
    purpose    = "terraform-state"
    managed_by = "terraform-bootstrap"
    env        = var.env_name
  }

  depends_on = [google_project_service.apis]
}

# ── 3. Dedicated CircleCI SA for THIS project ─────────────────
# Individual SA per project — least privilege security
# SA name: circleci-tf-<env>  e.g. circleci-tf-tms-dev
resource "google_service_account" "circleci" {
  project      = var.project_id
  account_id   = "circleci-tf-${var.env_name}"
  display_name = "CircleCI Terraform — ${var.env_name}"
  description  = "Dedicated CI/CD SA for ${var.env_name} only"

  depends_on = [google_project_service.apis]
}

# Editor on its own project only
resource "google_project_iam_member" "circleci_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.circleci.email}"
}

# Storage admin for state bucket access
resource "google_project_iam_member" "circleci_storage" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.circleci.email}"
}

# ── 4. OPTIONAL: Grant host project network access ────────────
# Service projects need their SA to have networkUser on HOST
# project to deploy into shared VPC subnets.
# Pass host_project_id for service/analytics projects.
resource "google_project_iam_member" "network_user_on_host" {
  count = var.host_project_id != "" ? 1 : 0

  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_service_account.circleci.email}"
}
