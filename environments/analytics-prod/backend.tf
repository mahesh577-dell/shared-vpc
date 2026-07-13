terraform {
  backend "gcs" {
    bucket = "freightfox-tfstate-analytics-prod"
    prefix = "terraform/state"
  }
}
