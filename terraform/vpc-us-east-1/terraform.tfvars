terraform {
  backend "s3" {
    bucket = "e1-terraform-state"
    key    = "chef/vpc-us-east-1/terraform.tfstate"
    dynamodb_table = "chef-vpc-us-east-1"
    region = "us-east-1"
  }
}
