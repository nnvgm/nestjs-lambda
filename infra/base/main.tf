provider "aws" {
  profile = var.aws_profile
}

terraform {
  backend "s3" {
    bucket = "terraform-be-state"
    key    = "base-example.tfstate"
    region = "ap-southeast-1"
  }
}
