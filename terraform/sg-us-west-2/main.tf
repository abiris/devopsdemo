terraform {
  backend "s3" {
    bucket = "e1-terraform-state"
    key    = "demo/sg-us-west-2/terraform.tfstate"
    dynamodb_table = "demo-sg-us-west-2"
    region = "us-east-1"
  }
}
variable "region" {
  default = "us-west-2"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_region" "current" {
  current = true
}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "e1-terraform-state"
        key = "demo/vpc-us-west-2/terraform.tfstate"
        region = "us-east-1"
    }
}

