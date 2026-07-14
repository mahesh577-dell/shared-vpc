terraform {
  backend "gcs" {
    # State bucket lives IN vms-staging project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-vms-staging"
    prefix = "terraform/state"
  }
}
