terraform {
  backend "gcs" {
    # State bucket lives IN vms-prod project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-vms-prod"
    prefix = "terraform/state"
  }
}
