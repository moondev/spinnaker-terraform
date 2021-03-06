
#
#	Variables to be updated by each user
#
region = "us-west-2"
vpc_cidr = "192.168.0.0/16"
vpc_name = "vpc_DIFFNAME"
ssh_key_name = "my-aws-account-keypair"

ssh_private_key_location = "/Users/jpancoast/.ssh/id_rsa_spinnaker_terraform"
ssh_public_key_location = "/Users/jpancoast/.ssh/id_rsa_spinnaker_terraform.pub"

jenkins_admin_username = "admin"
jenkins_admin_password = "admin123"

packer_url = "https://dl.bintray.com/mitchellh/packer/packer_0.8.6_linux_amd64.zip"
jenkins_instance_type = "t2.small"
bastion_instance_type = "t2.micro"
spinnaker_instance_type = "m4.2xlarge"

created_by = "Kenzan Spinnaker Terraform"

internal_dns_zone = "kenzan.int"

#
#	For the following '..._incoming_cidrs', you can use a comma separated list of incoming CIDRS
#

#
#	adm_bastion is inbound to port 22
#
adm_bastion_incoming_cidrs = "38.75.226.18/32,67.190.184.208/32"

#
#	infra_jenkins are inbound to port 80
#
infra_jenkins_incoming_cidrs = "38.75.226.18/32,67.190.184.208/32"


#
#	Stuff that you probably won't have to update that often
#
ppa_repo_key = "C2518248EEA14886"
ssh_user = "ubuntu"
