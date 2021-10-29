provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    key = "dev/mstfstate"
    bucket = "emess"
    region = "ap-south-1"
  }
}