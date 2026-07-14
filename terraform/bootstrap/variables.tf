# ── Required Parameters ───────────────────────────────────────
variable "project_id" {
  description = "GCP project ID to bootstrap"
  type        = string
}

variable "env_name" {
  description = "Environment name (host-dev, tms-dev, vms-dev, analytics-dev...)"
  type        = string
}

variable "project_type" {
  description = "Project type — decides which APIs to enable"
  type        = string

  validation {
    condition     = contains(["host", "service", "analytics"], var.project_type)
    error_message = "project_type must be one of: host, service, analytics"
  }
}

# ── Optional Parameters ───────────────────────────────────────
variable "region" {
  description = "GCP Region for state bucket"
  type        = string
  default     = "asia-south1"
}

variable "host_project_id" {
  description = "Host project ID — set for SERVICE/ANALYTICS projects so their SA gets networkUser on host shared VPC (empty = skip)"
  type        = string
  default     = ""
}
