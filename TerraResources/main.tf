provider "aws" {
	shared_credentials_file = "${var.credentials-file}"
	profile = "${var.profile}"
	region  = "${var.region}"
}
data "aws_availability_zones" "all" {}

resource "aws_instance" "OrJava" {
	ami = "${lookup(var.amis,var.region)}"
	count = "${var.count}"
	key_name = "${var.key-name}"
	vpc_security_group_ids = ["${aws_security_group.instace.id}"]
	source_dest_check = false
	instance_type = "t2.small"

	tags {
		Name = "${format("OrJava-%03d", count.index + 1)}" }
}
resource "aws_launch_configuration" "Japp" {
	image_id = "${lookup(var.amis,var.region)}"
	instance_type = "t2.small"
	security_groups = ["${aws_security_group.instance.id}"]
	key_name = "${var.key-name}"
	user_data = <<-EOF
			#!/bin/bash
			yum update -y
			yum install docker -y
			EOF
	lifycycle {
		create_before_destroy = true
	}
}
resource "aws_elb" "Japp" {
	name = "Japp"
	security_groups = ["${aws_security_group.elb.id}"]
	availability_zones = ["${data.aws_availability_zones.all.name}"]
	health_check {
		healthy_threshold = 2
		unhealthy_threshold = 2
		timeout = 5 
		interval = 20
		target = "HTTP:8080/"
	}
	listner {
		lb_port = 80
		lb_protocol = "http"
		instance_port = "8080"
		instance_protocol = "http"
	}
}