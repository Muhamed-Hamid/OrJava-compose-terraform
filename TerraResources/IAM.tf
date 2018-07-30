resource "aws_iam_role" "Japp" {
	name = "Japp"
	path = "/"
	assume_role_policy = "${file("./policy/japp.json")}" }

resource "aws_iam_role_policy_attachement" "Japp" {
	name = ""

resource "aws_security_group" "Japp-group" {
	name = "Japp-group"
	vpc_id = "${aws_vpc.vpc.id}"
	egress {
		from_port = 0
		to_port = 0
		cidr_block = "[0.0.0.0/0]"
		protocol = "-1"
	}
	tags {
		Name = "${var.env}-Japp"
		Env = "${var.env}"
	}
}
resource "aws_security_group_rule" "inbound" {
	from_port = 1025
	to_port = 65535
	type = "ingress"
	security_group_id = "${aws_security_group.Japp-group.id}"
	source_security_group_id = "${aws_security_group.Japp.id}"
	description = "Allow connection"
	protocol = "-1"
}
resource "aws_autoscaling_group" "Japp" {
	launch_configuration = "${aws_launch_configuration.Japp.id}"
	availability_zone = ["${data.aws_availability_zones.all.names}"]
	min_size = 2
	max_size = 5
	load_balancers = ["${aws_elb.Japp.name}"]
	health_check_type = "ELB"
	tags {
		key = "Name"
		value = "Java App"
		propagate_at_launch = true
	}
}
resource "aws_security_group" "elb" {
	name = "Japp"
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 0
		to_port = 0
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}
resource "aws_security_group" "ec2" {
	name = "Japp-stage"
	ingress = {
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}