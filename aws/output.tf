
resource "template_file" "output" {
	filename = "../files/output.tpl"

	vars {
		jenkins_public_ip = "${aws_instance.jenkins.public_ip}"
		bastion_public_ip = "${aws_instance.bastion.public_ip}"
		bastion_ip = "${aws_instance.bastion.public_ip}"
		private_key = "${var.ssh_private_key_location}"
		spinnaker_ip = "${aws_instance.spinnaker.private_ip}"
		ssh_user = "${var.ssh_user}"
		sg_id = "${aws_security_group.example_app.id}"
		vpc_sg_id = "${aws_security_group.vpc_sg.id}"
		mgmt_sg_id = "${aws_security_group.mgmt_sg.id}"
		vpc_name = "${var.vpc_name}"
		aws_region = "${var.region}"
		vpc_id = "${aws_vpc.main.id}"
	}
}

output "" {
	value = "${template_file.output.rendered}"
}