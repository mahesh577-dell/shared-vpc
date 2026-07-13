terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-vms-prod"
    prefix = "terraform/state"
  }
}
