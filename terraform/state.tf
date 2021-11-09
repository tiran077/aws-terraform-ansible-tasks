terraform {
  backend "s3" {
    bucket = "task-terraform"
    key    = "state.tfstate"
    region = "us-east-1"
  }
}