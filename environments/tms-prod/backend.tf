terraform {
  backend "gcs" {
    # State bucket lives IN tms-prod project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-tms-prod"
    prefix = "terraform/state"
  }
}
