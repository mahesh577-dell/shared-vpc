variable "host_project_id" {
  description = "Host project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "service_project_ids" {
  description = "Service project IDs to attach"
  type        = list(string)
}
