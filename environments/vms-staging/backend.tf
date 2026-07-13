terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-vms-staging"
    prefix = "terraform/state"
  }
}
