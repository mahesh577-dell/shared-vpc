output "host_project_id" {
  value = google_compute_shared_vpc_host_project.host.project
}

output "service_projects" {
  value = [for sp in google_compute_shared_vpc_service_project.service : sp.service_project]
}
