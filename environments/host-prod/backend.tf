terraform {
  backend "gcs" {
    # State bucket lives IN host-prod project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-host-prod"
    prefix = "terraform/state"
  }
}
