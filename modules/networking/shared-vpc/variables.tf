variable "host_project_id" {
  description = "Host project ID that owns the VPC"
  type        = string
}

variable "service_project_ids" {
  description = "List of service project IDs to attach to host"
  type        = list(string)
}
