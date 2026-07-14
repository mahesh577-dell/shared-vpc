terraform {
  backend "gcs" {
    # State bucket lives IN host-dev project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-host-dev"
    prefix = "terraform/state"
  }
}
