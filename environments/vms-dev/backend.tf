terraform {
  backend "gcs" {
    # State bucket lives IN vms-dev project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-vms-dev"
    prefix = "terraform/state"
  }
}
