terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-tms-prod"
    prefix = "terraform/state"
  }
}
