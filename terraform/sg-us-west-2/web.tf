module "sg-web" {
  source             = "../sec-group"
  vpc_id             = "${data.terraform_remote_state.vpc.vpc_id}"
  name               = "${data.terraform_remote_state.vpc.name}_web"
  description        = "Security group to allow web access"
  tags               = {
                         Name = "${data.terraform_remote_state.vpc.name}_web"
                       }
}

module "sg-web-rule-http" {
  source             = "../sec-group-rule-cidr"
  protocol           = "tcp"
  from_port          = 80
  to_port            = 80
  security_group_id  = "${module.sg-web.sec_gr_id}"
}

output "sg_web_id" {
  value = "${module.sg-web.sec_gr_id}"
} 
