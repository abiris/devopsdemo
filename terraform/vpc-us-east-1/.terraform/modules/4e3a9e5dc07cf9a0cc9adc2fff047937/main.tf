variable "region" {
  description = "The AWS region"
}

variable "reg" {
  description = "The AWS region, short name; will be used for naming resources"
  default = {
    us-east-1      = "e1"
    us-west-2      = "w2"
  }
}

variable "cidr" {
  description = "The CIDR block to provision for the VPC"
  default = {
    us-east-1      = "10.200.0.0/16"
    us-west-2      = "10.210.0.0/16"
  }
}

variable "remote_access" {
  description = "The list of CIDR blocks from where we allow remote/ssh connections"
  default = ["1.2.3.4/32"]
}

variable "default_ec2_ami" {
  default = {
    us-east-1      = "ami-6edd3078"
    us-west-2      = "ami-45224425"
  }
}

output "region" {
  value = "${var.region}"
}

output "reg" {
  value = "${lookup(var.reg, var.region)}"
}

output "cidr" {
  value = "${lookup(var.cidr, var.region)}"
}

output "remote_access" {
  value = "${var.remote_access}"
}

output "dns_server" {
  value = "${cidrhost(lookup(var.reg, var.region), 2)}"
}

output "ec2_ami" {
  value = "${lookup(var.default_ec2_ami, var.region)}"
}

