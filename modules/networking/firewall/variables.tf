variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR for internal traffic rule"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for firewall rule names"
  type        = string
}
