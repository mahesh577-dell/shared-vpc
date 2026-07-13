terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-host-staging"
    prefix = "terraform/state"
  }
}
