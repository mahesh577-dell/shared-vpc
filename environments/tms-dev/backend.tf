terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-tms-dev"
    prefix = "terraform/state"
  }
}
