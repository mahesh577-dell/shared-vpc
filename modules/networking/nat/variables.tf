variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "nat_name" {
  description = "NAT name"
  type        = string
}

variable "router_name" {
  description = "Router name to attach NAT"
  type        = string
}

variable "subnet_self_links" {
  description = "List of private subnet self links to apply NAT"
  type        = list(string)
}
