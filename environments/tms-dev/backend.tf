terraform {
  backend "gcs" {
    # State bucket lives IN tms-dev project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-tms-dev"
    prefix = "terraform/state"
  }
}
