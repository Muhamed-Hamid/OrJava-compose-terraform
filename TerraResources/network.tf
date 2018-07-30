resource "aws_vpc" "app-vpc"{
    cidr_block = "${var.vpc}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags { 
        Name = "${var.env}-Japp"
        Env = "${var.env}"
    }
}
resource "aws_internet_gateway" "IGW"{
    vpc_id = "${aws_vpc.vpc.id}"
    tags {
        Name = "${var.env}-igw"
        Env = "${var.env}"
    }
}
resource "aws_eip" "nat-ip" {
    vpc = true
    depends_on = ["aws_internet_gateway.IGW"]
}
resource "aws_nat_gateway" "natting" {
    allocation_ip = "${aws_eip.nat-ip}"
    subnet_id = "${element(aws_subnet.public_sub.*.id, 0)}"
    depends_on = ["aws_internet_gateway.IGW"]

    tags {
	Name = "${var.env}.${element(var.availability_zones, count.index)}-natting"
	Env = "${var.env}"
	}
}
resource "aws_subnet" "sub-1a-priv" {
    vpc_id = "${aws_vpc.vpc_id}"
    cidr_block = "${var.subnet-1a-priv["cidr_block"]}"
    availability_zone = "${var.region}a"
    tags {
        Name  = "${var.env}-sub-1a-priv"
        Env  = "${var.env}"
    }
}
resource "aws_route_table" "route-1a-priv" {
    vpc_id = "${aws_vpc.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW.id}"
    }
    tags {
        Name = "${var.env}-route-1a-priv"
        Env = "${var.env}"
    }
}
resource "aws_route_table_association" "route-1a-priv" {
    subnet_id = "${aws_subnet.sub-1a-priv.id}"
    route_table = "${aws_route_table.route-1a-priv.id}"
}
resource "aws_subnet" "subnet-1b-priv"{
    vpc_id = "${aws_vpc.vpc_id}"
    cidr_block = "${var.subnet-1b-priv["cidr_block"]}"
    availability_zone = "${var.region}b"
    tags {
        Name = "${var.env}-route-1b-priv"
        Env = "${var.env}" 
    }
}
resource "aws_route_table" "route-1b-priv" {
    vpc_id = "${aws_vpc.vpc_id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.IGW.id}"
    }
    tags {
        Name = "${var.env}-route-1b-priv"
        Env = "${var.env}"
    }
}
resource "aws_route_table_association" "route-1b-priv" {
    subnet_id = "${aws_subnet.sub-1b-priv.id}"
    route_table = "${aws_route_table.route-1b-priv.id}"
}