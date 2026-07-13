terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-vms-dev"
    prefix = "terraform/state"
  }
}
