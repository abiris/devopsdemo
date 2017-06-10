variable "name" {
  description = "Name tag"
  default     = ""
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "region" {
  description = "The region for the VPC."
}

variable "external_subnets" {
  description = "List of external subnets"
  type        = "list"
}

variable "internal_subnets" {
  description = "List of internal subnets"
  type        = "list"
}

variable "availability_zones" {
  description = "List of availability zones, describe just by the zone letter"
  type        = "list"
}

variable "s3-service-name" {
  description = "S3 service name for endpoints creation"
  default = {
    us-east-1      = "com.amazonaws.us-east-1.s3"
    us-west-2      = "com.amazonaws.us-west-2.s3"
  }
}


/**
 * VPC
 */

resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name        = "${var.name}"
  }
}

/**
 * Gateways
 */

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name        = "${var.name}"
  }
}

resource "aws_nat_gateway" "main" {
  count         = "${length(var.internal_subnets)}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.external.*.id, count.index)}"
  depends_on    = ["aws_internet_gateway.main"]
}

resource "aws_eip" "nat" {
  count = "${length(var.internal_subnets)}"
  vpc   = true
}

resource "aws_vpn_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_vpn_gateway_attachment" "vpn_gw_attachment" {
  vpc_id = "${aws_vpc.main.id}"
  vpn_gateway_id = "${aws_vpn_gateway.main.id}"
}

/**
 * Subnets.
 */

resource "aws_subnet" "internal" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${element(var.internal_subnets, count.index)}"
  availability_zone = "${var.region}${element(var.availability_zones, count.index)}"
  count             = "${length(var.internal_subnets)}"

  tags {
    Name = "${var.name}-int-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_subnet" "external" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${element(var.external_subnets, count.index)}"
  availability_zone       = "${var.region}${element(var.availability_zones, count.index)}"
  count                   = "${length(var.external_subnets)}"
  map_public_ip_on_launch = true

  tags {
    Name = "${var.name}-ext-${element(var.availability_zones, count.index)}"
  }
}

/**
 * Route tables
 */

resource "aws_route_table" "external" {
  vpc_id = "${aws_vpc.main.id}"
  propagating_vgws = ["${aws_vpn_gateway.main.id}"]
  tags {
    Name = "${var.name}-external"
  }
}

resource "aws_route" "external" {
  route_table_id         = "${aws_route_table.external.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main.id}"
}

resource "aws_route_table" "internal" {
  count  = "${length(var.internal_subnets)}"
  vpc_id = "${aws_vpc.main.id}"
  propagating_vgws = ["${aws_vpn_gateway.main.id}"]

  tags {
    Name = "${var.name}-int-${element(var.availability_zones, count.index)}"
  }
}

resource "aws_route" "internal" {
  count                  = "${length(compact(var.internal_subnets))}"
  route_table_id         = "${element(aws_route_table.internal.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.main.*.id, count.index)}"
}

/**
 * Route associations
 */

resource "aws_route_table_association" "internal" {
  count          = "${length(var.internal_subnets)}"
  subnet_id      = "${element(aws_subnet.internal.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.internal.*.id, count.index)}"
}

resource "aws_route_table_association" "external" {
  count          = "${length(var.external_subnets)}"
  subnet_id      = "${element(aws_subnet.external.*.id, count.index)}"
  route_table_id = "${aws_route_table.external.id}"
}

resource "aws_vpc_endpoint" "main-endpoint-s3" {
    vpc_id = "${aws_vpc.main.id}"
    service_name = "${lookup(var.s3-service-name, var.region)}"
    route_table_ids = ["${concat(aws_route_table.internal.*.id, list(aws_route_table.external.id))}"]
}

/**
 * Outputs
 */

// The VPC ID
output "id" {
  value = "${aws_vpc.main.id}"
}

// The VPC name
output "name" {
  value = "${var.name}"
}

// The VPC region
output "region" {
  value = "${var.region}"
}

// The VPC IP range
output "cidr" {
  value = "${var.cidr}"
}

// A comma-separated list of subnet IDs.
output "external_subnets" {
  value = ["${aws_subnet.external.*.id}"]
}

// A list of subnet IDs.
output "internal_subnets" {
  value = ["${aws_subnet.internal.*.id}"]
}

// The default VPC security group ID. TO NEVER EVER USE
output "security_group" {
  value = "${aws_vpc.main.default_security_group_id}"
}

// The list of availability zones of the VPC.
output "availability_zones" {
  value = "${var.availability_zones}"
}

// The internal route table ID.
output "internal_rtb_id" {
  value = ["${aws_route_table.internal.*.id}"]
}

// The external route table ID.
output "external_rtb_id" {
  value = "${aws_route_table.external.id}"
}

// The list of EIPs associated with the internal subnets.
output "internal_nat_ips" {
  value = ["${aws_eip.nat.*.public_ip}"]
}

// VPN Gateway ID
output "vpn_gw_id" {
  value = "${aws_vpn_gateway.main.id}"
}

// S3 endpoint ID main-endpoint-s3
output "s3_endpoint_id" {
  value = "${aws_vpc_endpoint.main-endpoint-s3.id}"
}
