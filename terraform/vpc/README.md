## VPC

This module creates a VPC.

Usage:

```
module "vpc" {
  source             = "s3/path"
  name               = "${var.name}"
  cidr               = "${var.cidr}"
  internal_subnets   = "${var.internal_subnets}"
  external_subnets   = "${var.external_subnets}"
  availability_zones = "${var.availability_zones}"
  environment        = "${var.environment}"
}
```

Outputs:

id - The VPC ID

external_subnets - list of external subnet IDs.

internal_subnets - list of internal subnet IDs.

security_group - The default VPC security group ID. TO NEVER EVER USE

availability_zones - The list of availability zones of the VPC.

internal_rtb_id - List of the internal route table IDs.

external_rtb_id - The external route table ID.

internal_nat_ips - The list of EIPs associated with the NAT GWs.
