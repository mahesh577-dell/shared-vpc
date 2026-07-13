variable "project_id" {
  description = "TMS DEV service project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "asia-south1"
}

variable "host_project_id" {
  description = "Host project ID that owns the shared VPC"
  type        = string
}

variable "host_vpc_id" {
  description = "Host VPC network ID — from host-dev environment output"
  type        = string
}

variable "tms_dev_private_subnet" {
  description = "TMS DEV private subnet self link — from host-dev output"
  type        = string
}
