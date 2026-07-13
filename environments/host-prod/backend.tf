terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-host-prod"
    prefix = "terraform/state"
  }
}
