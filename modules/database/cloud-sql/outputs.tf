output "instance_name" {
  value = google_sql_database_instance.instance.name
}

output "private_ip" {
  value = google_sql_database_instance.instance.private_ip_address
}

output "connection_name" {
  value = google_sql_database_instance.instance.connection_name
}

# Expose password so tms-dev/main.tf can pass to secret-manager module
output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}
