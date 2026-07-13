variable "project_id" {
  description = "GCP Project ID for bootstrap"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}
