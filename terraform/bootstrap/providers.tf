terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  # LOCAL backend intentional — bootstrap creates the GCS buckets!
  # Use -state flag to keep separate state per project:
  # terraform apply -state="states/host-dev.tfstate" ...
  backend "local" {}
}

provider "google" {
  project = var.project_id
  region  = var.region
}
