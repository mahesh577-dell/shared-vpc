terraform {
  backend "gcs" {
    # State bucket lives IN analytics-prod project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-analytics-prod"
    prefix = "terraform/state"
  }
}
