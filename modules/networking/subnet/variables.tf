variable "project_id" {
  description = "Host project ID — subnets created in host project"
  type        = string
}

variable "region" {
  description = "GCP Region — subnets are regional in GCP (not per zone like AWS)"
  type        = string
  default     = "asia-south1"
}

variable "vpc_self_link" {
  description = "VPC self link from vpc module output"
  type        = string
}

variable "flow_sampling" {
  description = "Flow log sampling (0.1=dev, 0.5=staging, 1.0=prod)"
  type        = number
  default     = 0.1
}

variable "subnets" {
  description = "Map of subnets to create in host project"
  type = map(object({
    cidr                     = string
    description              = optional(string, "")
    private_ip_google_access = optional(bool, false)
    secondary_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
  default = {}
}
