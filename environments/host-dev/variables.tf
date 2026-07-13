variable "host_project_id" {
  description = "Host project ID that owns the shared VPC"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "service_project_ids" {
  description = "Service project IDs to attach to shared VPC"
  type        = list(string)
}
