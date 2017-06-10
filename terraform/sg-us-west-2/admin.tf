module "sg-admin" {
  source             = "../sec-group"
  vpc_id             = "${data.terraform_remote_state.vpc.vpc_id}"
  name               = "${data.terraform_remote_state.vpc.name}_admin"
  description        = "Security group to allow remote/ssh access, icmp traffic and access to VPC endpoints, to attach on all machines"
  tags               = {
                         Name = "${data.terraform_remote_state.vpc.name}_admin"
                       }
}

module "sg-admin-rule-icmp" {
  source             = "../sec-group-rule-cidr"
  protocol           = "icmp"
  from_port          = 30
  to_port            = 0
  security_group_id  = "${module.sg-admin.sec_gr_id}"
}

module "sg-admin-rule-ssh" {
  source             = "../sec-group-rule-cidr"
  protocol           = "tcp"
  from_port          = 22
  to_port            = 22
  security_group_id  = "${module.sg-admin.sec_gr_id}"
}

output "sg_admin_id" {
  value = "${module.sg-admin.sec_gr_id}"
} 
