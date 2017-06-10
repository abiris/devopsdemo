variable "type" {
  description = "ingress/egress rule type"
  default = "ingress"
}

variable "from_port" {
  description = "Interger, start port range for sec gr rule"
  default = 80
}

variable "to_port" {
  description = "Interger, range port end for sec gr rule"
  default = 80
}

variable "cidr" {
  description = "List of source IP range"
  type = "list"
  default = ["0.0.0.0/0"]
}

variable "protocol" {
  description = "icmp/udp/tcp or protocol number used for this rule"
  default = "tcp"
}

variable "security_group_id" {
  description = "Security group ID for the group where we attach this rule"
}

resource "aws_security_group_rule" "sec_gr_rule" {
    type = "${var.type}"
    from_port = "${var.from_port}"
    to_port = "${var.to_port}"
    protocol = "${var.protocol}"
    cidr_blocks = "${var.cidr}"
    security_group_id = "${var.security_group_id}"
}

output "sec_gr_rule_id" {
  value = "${aws_security_group_rule.sec_gr_rule.id}"
}

output "sec_gr_rule_type" {
  value = "${aws_security_group_rule.sec_gr_rule.type}"
}

output "sec_gr_rule_from_port" {
  value = "${aws_security_group_rule.sec_gr_rule.from_port}"
}

output "sec_gr_rule_to_port" {
  value = "${aws_security_group_rule.sec_gr_rule.to_port}"
}

output "sec_gr_rule_protocol" {
  value = "${aws_security_group_rule.sec_gr_rule.protocol}"
}

