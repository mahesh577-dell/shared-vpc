# ═══════════════════════════════════════════════════════════════
# MODULE: security/secret-manager
# AWS EQUIVALENT: AWS Secrets Manager
#
# PURPOSE:
# Stores ALL secrets centrally:
# → Database passwords
# → API keys
# → JWT secrets
# → Third party credentials
#
# HOW APPS ACCESS:
# Apps use service account with secretAccessor role
# gcloud secrets versions access latest --secret=SECRET_NAME
# ═══════════════════════════════════════════════════════════════

resource "google_secret_manager_secret" "secret" {
  secret_id = var.secret_name
  project   = var.project_id

  replication {
    auto {}
  }

  labels = var.labels
}

resource "google_secret_manager_secret_version" "secret_version" {
  secret      = google_secret_manager_secret.secret.id
  secret_data = var.secret_value
}
