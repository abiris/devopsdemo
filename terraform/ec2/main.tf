terraform {
  backend "s3" {
    bucket = "e1-terraform-state"
    key    = "demo/ec2-us-west-2/terraform.tfstate"
    dynamodb_table = "demo-ec2-us-west-2"
    region = "us-east-1"
  }
}

variable "region" {
  default = "us-west-2"
}

provider "aws" {
  region = "${var.region}"
}

module "defaults" {
  source = "../defaults"
  region = "us-west-2"
}

data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket = "e1-terraform-state"
        key = "demo/vpc-us-west-2/terraform.tfstate"
        region = "us-east-1"
    }
}

data "terraform_remote_state" "sgw2" {
    backend = "s3"
    config {
        bucket = "e1-terraform-state"
        key = "demo/sg-us-west-2/terraform.tfstate"
        region = "us-east-1"
    }
}
