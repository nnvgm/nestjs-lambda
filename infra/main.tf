provider "aws" {
  profile = var.aws_profile
}

terraform {
  backend "s3" {
    bucket                      = "terraform-be-state"
    key                         = "nestjs-lambda-example.tfstate"
    region                      = var.region
  }
}
