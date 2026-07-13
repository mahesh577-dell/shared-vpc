output "cloud_sql_instance" {
  value = module.db.instance_name
}

output "cloud_sql_private_ip" {
  value = module.db.private_ip
}

output "db_password_secret" {
  description = "Fetch DB password: gcloud secrets versions access latest --secret=tms-dev-db-password"
  value       = module.db_secret.secret_id
}
