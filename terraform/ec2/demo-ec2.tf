resource "aws_instance" "demo" {
  connection {
    user = "ubuntu"
  }

  instance_type = "t2.medium"
  ami = "ami-09565f70"
  key_name = "demo"
  vpc_security_group_ids = ["${data.terraform_remote_state.sgw2.sg_admin_id}"]
  subnet_id = "subnet-c0732689"
  associate_public_ip_address = true
  tags {
    Name = "demo"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ../../ansible/ec2.py ../../ansible/terra_demo.yml --key-file=~/.ssh/demo.pem --user=ubuntu"
  }
}

output "demo_ip" {
  value = "${aws_instance.demo.public_ip}"
}
