terraform {
  backend "gcs" {
    # State bucket lives IN analytics-dev project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-analytics-dev"
    prefix = "terraform/state"
  }
}
