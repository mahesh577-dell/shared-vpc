variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "router_name" {
  description = "Router name"
  type        = string
}

variable "vpc_id" {
  description = "VPC network ID"
  type        = string
}

variable "bgp_asn" {
  description = "BGP ASN unique per router (tms-dev=64514, tms-prod=64516)"
  type        = number
  default     = 64514
}
