variable "region" {
	type = string
	default = "ap-southeast-1"
}
variable "vpc_cidr" {
	type = string
	default = "192.168.0.0/22"
}
variable "subnet_cidrs" {
	type = list(string)
	default = ["192.168.1.0/24","192.168.2.0/24","192.168.3.0/24"]
}
variable "ami" {
	type = string
	default = "ami-0f7719e8b7ba25c61"
}
variable "instance_type" {
	type = string
	default = "t2.micro"
}
variable "key_pair" {
	type = string
	default = "kafka-keypair"
}
variable "iam_bastion_role" {
	type = string
	default = "alert-management-kafka-oracle-bastion-instance-role"
}