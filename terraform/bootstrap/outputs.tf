output "project_id" {
  value = var.project_id
}

output "state_bucket" {
  description = "State bucket created in this project"
  value       = google_storage_bucket.tfstate.name
}

output "apis_enabled" {
  description = "APIs enabled in this project"
  value       = [for a in google_project_service.apis : a.service]
}

output "circleci_sa_email" {
  description = "Dedicated CircleCI SA — create key and add to CircleCI context gcp-<env>"
  value       = google_service_account.circleci.email
}

output "circleci_context_name" {
  description = "Suggested CircleCI context name for this SA key"
  value       = "gcp-${var.env_name}"
}
