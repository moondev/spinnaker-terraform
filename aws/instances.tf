
/* bastion instance */
resource "aws_instance" "bastion" {
  ami = "${module.tf_aws_kenzan_spinnaker.ubuntu_ami_id}"
  instance_type = "${var.bastion_instance_type}"
  subnet_id = "${aws_subnet.public_subnet.3.id}"
  vpc_security_group_ids = ["${aws_security_group.adm_bastion.id}", "${aws_security_group.vpc_sg.id}", "${aws_security_group.mgmt_sg.id}"]
  associate_public_ip_address=true
  key_name = "${var.ssh_key_name}"
  tags = {
    Name = "bastion host"
    created_by = "${var.created_by}"
  }

  connection {
    user = "${var.ssh_user}"
    key_file = "${var.ssh_private_key_location}"
    agent = false
  }

  provisioner "file" {
    source = "${var.ssh_private_key_location}"
    destination = "/home/${var.ssh_user}/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 0600 /home/${var.ssh_user}/.ssh/id_rsa"
    ]
  }
}

/* jenkins instance */
resource "aws_instance" "jenkins" {
  ami = "${module.tf_aws_kenzan_spinnaker.ubuntu_ami_id}"
  instance_type = "${var.jenkins_instance_type}"
  subnet_id = "${aws_subnet.public_subnet.4.id}"
  vpc_security_group_ids = ["${aws_security_group.infra_jenkins.id}", "${aws_security_group.vpc_sg.id}", "${aws_security_group.mgmt_sg.id}"]
  associate_public_ip_address=true
  key_name = "${var.ssh_key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.jenkins_instance_profile.id}"

  connection {
    user = "${var.ssh_user}"
    bastion_host = "${aws_instance.bastion.public_ip}"
    bastion_user = "${var.ssh_user}"
    key_file = "${var.ssh_private_key_location}"
    host = "${aws_instance.jenkins.private_ip}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/terraform/"
    ]
  }

  provisioner "file" {
    source = "../files/jenkins/"
    destination = "/tmp/terraform"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod a+x /tmp/terraform/provision.sh",
      "sudo /tmp/terraform/provision.sh ${var.jenkins_admin_username} ${var.jenkins_admin_password} ${var.ppa_repo_key} ${var.packer_url}"
    ]
  }

  tags = {
    Name = "Jenkins host"
    created_by = "${var.created_by}"
  }
}

/* Spinnaker instance */
resource "aws_instance" "spinnaker" {
  ami = "${module.tf_aws_kenzan_spinnaker.spinnaker_ami_id}"
  instance_type = "${var.spinnaker_instance_type}"
  subnet_id = "${aws_subnet.public_subnet.5.id}"
  vpc_security_group_ids = ["${aws_security_group.infra_spinnaker.id}", "${aws_security_group.vpc_sg.id}", "${aws_security_group.mgmt_sg.id}"]
  associate_public_ip_address=true
  key_name = "${var.ssh_key_name}"
  iam_instance_profile = "${aws_iam_instance_profile.spinnaker_instance_profile.id}"

  connection {
    user = "${var.ssh_user}"
    bastion_host = "${aws_instance.bastion.public_ip}"
    bastion_user = "${var.ssh_user}"
    key_file = "${var.ssh_private_key_location}"
    host = "${aws_instance.spinnaker.private_ip}"
    agent = false
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p /tmp/terraform/"
    ]
  }

  provisioner "file" {
    source = "../files/spinnaker/"
    destination = "/tmp/terraform"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod a+x /tmp/terraform/provision.sh",
      "sudo /tmp/terraform/provision.sh ${var.region} ${var.internal_dns_zone} ${var.jenkins_admin_username} ${var.jenkins_admin_password}"
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod a+x /home/ubuntu/.init-region",
      "/home/ubuntu/.init-region",
      "echo init region done.",
      "sudo service spinnaker restart"
    ]
  }

  tags = {
    Name = "Spinnaker host"
    created_by = "${var.created_by}"
  }
}
