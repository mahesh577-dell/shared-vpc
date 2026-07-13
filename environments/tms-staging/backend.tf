terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-tms-staging"
    prefix = "terraform/state"
  }
}
