terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-host-dev"
    prefix = "terraform/state"
  }
}
