terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-analytics-dev"
    prefix = "terraform/state"
  }
}
