variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "secret_name" {
  description = "Secret name — e.g. tms-dev-db-password, tms-dev-api-key"
  type        = string
}

variable "secret_value" {
  description = "The actual secret value to store"
  type        = string
  sensitive   = true
}

variable "labels" {
  description = "Labels to apply to the secret"
  type        = map(string)
  default     = {}
}
