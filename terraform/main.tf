provider "aws" {
	region = var.region
}

######################## Create VPC ###############################
resource "aws_vpc" "alert-management-kafka-oracle-vpc" {
	cidr_block = var.vpc_cidr
	enable_dns_hostnames = true
	tags = {
		Name = "alert-management-kafka-oracle-vpc"
	}
}
#################### Create Internet gateway ###############
resource "aws_internet_gateway" "alert-management-kafka-oracle-igw" {
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	tags = {
		Name = "alert-management-kafka-oracle-igw"
	}
	depends_on = [aws_vpc.alert-management-kafka-oracle-vpc]
}
################### Create main route table for VPC ##############
resource "aws_route_table" "alert-management-kafka-oracle-routetable" {
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.alert-management-kafka-oracle-igw.id
	}
	tags = {
		Name = "alert-management-kafka-oracle-routetable"
	}
	depends_on = [aws_vpc.alert-management-kafka-oracle-vpc]
}
##################### Create subnet in 3 availibility zones ################
resource "aws_subnet" "alert-management-kafka-oracle-subnet1" {
	availability_zone = "${var.region}a"
	cidr_block = var.subnet_cidrs[0]
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	tags = {
		Name = "alert-management-kafka-oracle-subnet1"
	}
	depends_on = [aws_route_table.alert-management-kafka-oracle-routetable]
}
resource "aws_subnet" "alert-management-kafka-oracle-subnet2" {
	availability_zone = "${var.region}b"
	cidr_block = var.subnet_cidrs[1]
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	tags = {
		Name = "alert-management-kafka-oracle-subnet2"
	}
	depends_on = [aws_route_table.alert-management-kafka-oracle-routetable]
}
resource "aws_subnet" "alert-management-kafka-oracle-subnet3" {
	availability_zone = "${var.region}c"
	cidr_block = var.subnet_cidrs[2]
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	tags = {
		Name = "alert-management-kafka-oracle-subnet3"
	}
	depends_on = [aws_route_table.alert-management-kafka-oracle-routetable]
}
################### Create subnet association with main route table #######################
resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.alert-management-kafka-oracle-subnet1.id
  route_table_id = aws_route_table.alert-management-kafka-oracle-routetable.id
  depends_on = [aws_subnet.alert-management-kafka-oracle-subnet1]
}
resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.alert-management-kafka-oracle-subnet2.id
  route_table_id = aws_route_table.alert-management-kafka-oracle-routetable.id
  depends_on = [aws_subnet.alert-management-kafka-oracle-subnet2]
}
resource "aws_route_table_association" "subnet3" {
  subnet_id      = aws_subnet.alert-management-kafka-oracle-subnet3.id
  route_table_id = aws_route_table.alert-management-kafka-oracle-routetable.id
  depends_on = [aws_subnet.alert-management-kafka-oracle-subnet3]
}
#################### Create Kafka instances placement group ##########################
resource "aws_placement_group" "alert-management-kafka-oracle-placement-group" {
	name = "alert-management-kafka-oracle-placement-group"
	strategy = "partition"
	tags = {
		Name = "alert-management-kafka-oracle-placement-group"
	}
}