# ═══════════════════════════════════════════════════════════════
# MODULE: networking/shared-vpc
#
# PURPOSE:
# Enables Shared VPC (XPN) between host project and
# service projects. This module:
# 1. Enables host project as Shared VPC host
# 2. Attaches service projects to host project
# 3. Grants networkUser role to service project SAs
#
# HOW SHARED VPC WORKS:
# Host Project  → owns VPC + subnets
# Service Projects → deploy resources INTO host subnets
#
# USAGE:
# Called from host-dev / host-staging / host-prod environments
# ═══════════════════════════════════════════════════════════════

# Enable host project as Shared VPC host
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project_id
}

# Attach each service project to host project
resource "google_compute_shared_vpc_service_project" "service" {
  for_each        = toset(var.service_project_ids)
  host_project    = var.host_project_id
  service_project = each.value

  depends_on = [google_compute_shared_vpc_host_project.host]
}

# Grant networkUser role to service project default SAs
# This allows service projects to use host subnets
resource "google_project_iam_member" "network_user" {
  for_each = toset(var.service_project_ids)

  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${each.value}@cloudservices.gserviceaccount.com"

  depends_on = [google_compute_shared_vpc_service_project.service]
}

# Grant networkUser to GKE service accounts
resource "google_project_iam_member" "gke_network_user" {
  for_each = toset(var.service_project_ids)

  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-${each.value}@container-engine-robot.iam.gserviceaccount.com"

  depends_on = [google_compute_shared_vpc_service_project.service]
}
