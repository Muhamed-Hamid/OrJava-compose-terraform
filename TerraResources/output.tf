output "instance_ids" {
	value = ["${aws_instance.OrJava.*.public_ip}"] }

output "elb_dns_name" {
	value = "${aws_elb.Japp.dns_name}" }
