variable "credentials-file" {
	default = "/home/lord/.aws/credentials"
	profile = "stage" }

variable "count" {
	default = 1 }

variable "region" {
	description = " Region selected for testing "
	default = "us-east-1" }

variable "key-name" {
	description = "SSH access key name for our instance"
	default = "myjavakey" }
variable "env" {
	default = "stage" }

variable "amis" {
	type = "map"
	description = "Our Image to launch our ec2"
	default = { 
		us-east-1    = "ami-b73b63a0"
		eu-central-1 = "ami-e056690b"
		us-west-2    = "ami-5ec1673e" }

varible "aws_access_key_id" {
	default = ""
	description = "user access key" }

variable "aws_secret_access_key_id" {
	default = ""
	description = "User secret key" }

variable "vpc" {
	default = "192.168.0.0/16" }

variable "sub-1a-priv" {
    type = "map"
    default {
        cidr_block = "192.168.20.0/21"
    }
}
variable "sub-1b-priv" {
    type = "map"
    default {
        cidr_block = "192.168.21.0/21"
    }
}