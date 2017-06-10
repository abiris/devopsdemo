variable "name" {
  description = "Security group name"
}

variable "description" {
  description = "Description for this security group"
}

variable "vpc_id" {
  description = "VPC ID where the security group will be created; default is taken from the remote state defined above"
  type = "string"
}

variable "tags" {
  description = "Map of tags for this security group"
  type = "map"
}

resource "aws_security_group" "sec_gr" {
  name = "${var.name}"
  description = "${var.description}"
  vpc_id = "${var.vpc_id}"
  tags = "${var.tags}"
}

resource "aws_security_group_rule" "in_allow_self" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    self = true
    security_group_id = "${aws_security_group.sec_gr.id}"
}

resource "aws_security_group_rule" "out_allow_all" {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.sec_gr.id}"
}

output "sec_gr_id" {
  value = "${aws_security_group.sec_gr.id}"
}
