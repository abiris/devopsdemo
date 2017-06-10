# This is the main configuration file for US-East-1 region

variable "region" {
  default = "us-east-1"
}

provider "aws" {
  region = "${var.region}"
}

data "aws_region" "current" {
  current = true
}

module "defaults" {
  source = "../defaults"
  region = "${data.aws_region.current.name}"
}

module "vpc" {
  source             = "../vpc"
  name               = "chef_${module.defaults.reg}"
  cidr               = "${module.defaults.cidr}"
  region             = "${data.aws_region.current.name}"
  internal_subnets   = "${var.internal_subnets}"
  external_subnets   = "${var.external_subnets}"
  availability_zones = "${var.availability_zones}"
}


/**
 * Outputs
 */

// The VPC ID
output "vpc_id" {
  value = "${module.vpc.id}"
}

// The VPC name
output "name" {
  value = "${module.vpc.name}"
}

// The VPC region
output "region" {
  value = "${data.aws_region.current.name}"
}

// The VPC CIDR
output "cidr" {
  value = "${module.vpc.cidr}"
}

// The VPC CIDR list for remote access
output "remote_access" {
  value = "${module.defaults.remote_access}"
}

// DNS server for this VPC
output "dns_server" {
  value = "${module.defaults.dns_server}"
}

// Default ec2_ami for this VPC
output "ec2_ami" {
  value = "${module.defaults.ec2_ami}"
}

// A comma-separated list of subnet IDs.
output "external_subnets" {
  value = "${module.vpc.external_subnets}"
}

// A list of subnet IDs.
output "internal_subnets" {
  value = "${module.vpc.internal_subnets}"
}

// The default VPC security group ID. TO NEVER EVER USE
output "security_group" {
  value = "${module.vpc.security_group}"
}

// The list of availability zones of the VPC.
output "availability_zones" {
  value = "${module.vpc.availability_zones}"
}

// The internal route table ID.
output "internal_rtb_id" {
  value = ["${module.vpc.internal_rtb_id}"]
}

// The external route table ID.
output "external_rtb_id" {
  value = "${module.vpc.external_rtb_id}"
}

// The list of EIPs associated with the internal subnets.
output "internal_nat_ips" {
  value = ["${module.vpc.internal_nat_ips}"]
}

// S3 endpoint ID
output "s3_endpoint_id" {
  value = "${module.vpc.s3_endpoint_id}"
}

