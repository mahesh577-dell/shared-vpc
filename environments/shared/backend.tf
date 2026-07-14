terraform {
  backend "gcs" {
    # State bucket lives IN shared project
    # Created by terraform/bootstrap
    bucket = "freightfox-tfstate-shared"
    prefix = "terraform/state"
  }
}
