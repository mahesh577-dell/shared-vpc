terraform {
  backend "gcs" {
    # State bucket lives IN tms-staging project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-tms-staging"
    prefix = "terraform/state"
  }
}
