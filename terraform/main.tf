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
}
##################### Create subnet in 3 availibility zones ################
resource "aws_subnet" "alert-management-kafka-oracle-subnet1" {
	availability_zone = "${var.region}a"
	cidr_block = var.subnet_cidrs[0]
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	tags = {
		Name = "alert-management-kafka-oracle-subnet1"
	}
}
resource "aws_subnet" "alert-management-kafka-oracle-subnet2" {
	availability_zone = "${var.region}b"
	cidr_block = var.subnet_cidrs[1]
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	tags = {
		Name = "alert-management-kafka-oracle-subnet2"
	}
}
resource "aws_subnet" "alert-management-kafka-oracle-subnet3" {
	availability_zone = "${var.region}c"
	cidr_block = var.subnet_cidrs[2]
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	tags = {
		Name = "alert-management-kafka-oracle-subnet3"
	}
}
################### Create subnet association with main route table #######################
resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.alert-management-kafka-oracle-subnet1.id
  route_table_id = aws_route_table.alert-management-kafka-oracle-routetable.id
}
resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.alert-management-kafka-oracle-subnet2.id
  route_table_id = aws_route_table.alert-management-kafka-oracle-routetable.id
}
resource "aws_route_table_association" "subnet3" {
  subnet_id      = aws_subnet.alert-management-kafka-oracle-subnet3.id
  route_table_id = aws_route_table.alert-management-kafka-oracle-routetable.id
}
################### Create security groups ##################################
resource "aws_security_group" "alert-management-kafka-oracle-bastion-securitygroup" {
	name = "alert-management-kafka-oracle-bastion-securitygroup"
	description = "Security group for bastion instances"
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	ingress {
		description = "SSH traffic from Internet"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		description = "HTTP traffic from Internet"
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		description = "Any outbound traffic"
    	from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
  	}

  tags = {
    Name = "alert-management-kafka-oracle-bastion-securitygroup"
  }
}
resource "aws_security_group" "alert-management-kafka-oracle-elb-securitygroup" {
	name = "alert-management-kafka-oracle-elb-securitygroup"
	description = "Security group for load balancer"
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	ingress {
		description = "HTTP traffic from Internet"
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	ingress {
		description = "HTTP traffic from Internet"
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
	egress {
		description = "Any outbound traffic"
    	from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
  	}

  tags = {
    Name = "alert-management-kafka-oracle-elb-securitygroup"
  }
}
resource "aws_security_group" "alert-management-kafka-oracle-kafka-securitygroup" {
	name = "alert-management-kafka-oracle-kafka-securitygroup"
	description = "Security group for Kafka cluster"
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	ingress {
		description = "Zookeeper from VPC"
		from_port = 2181
		to_port = 2181
		protocol = "tcp"
		cidr_blocks = [aws_vpc.alert-management-kafka-oracle-vpc.cidr_block]
	}
	ingress {
		description = "Bootstrap servers/listeners from VPC"
		from_port = 9092
		to_port = 9092
		protocol = "tcp"
		cidr_blocks = [aws_vpc.alert-management-kafka-oracle-vpc.cidr_block]
	}
	ingress {
		description = "SSH from Bastion instances"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = [aws_security_group.alert-management-kafka-oracle-bastion-securitygroup.id]
	}
	egress {
		description = "Any outbound traffic"
    	from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
  	}

  tags = {
    Name = "alert-management-kafka-oracle-kafka-securitygroup"
  }
}
resource "aws_security_group" "alert-management-kafka-oracle-webserver-securitygroup" {
	name = "alert-management-kafka-oracle-webserver-securitygroup"
	description = "Security group for rest services cluster"
	vpc_id = aws_vpc.alert-management-kafka-oracle-vpc.id
	ingress {
		description = "HTTP traffic from ELB security group"
		from_port = 8080
		to_port = 8080
		protocol = "tcp"
		security_groups = [aws_security_group.alert-management-kafka-oracle-elb-securitygroup.id]
	}
	ingress {
		description = "HTTP traffic from ELB security group"
		from_port = 80
		to_port = 80
		protocol = "tcp"
		security_groups = [aws_security_group.alert-management-kafka-oracle-elb-securitygroup.id]
	}
	ingress {
		description = "SSH from Bastion instances"
		from_port = 22
		to_port = 22
		protocol = "tcp"
		security_groups = [aws_security_group.alert-management-kafka-oracle-bastion-securitygroup.id]
	}
	egress {
		description = "Any outbound traffic"
    	from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
  	}

  tags = {
    Name = "alert-management-kafka-oracle-webserver-securitygroup"
  }
}
#################### Create Bastion instance ##########################
resource "aws_placement_group" "alert-management-kafka-oracle-placement-group" {
	name = "alert-management-kafka-oracle-placement-group"
	strategy = "partition"
	tags = {
		Name = "alert-management-kafka-oracle-placement-group"
	}
}
resource "aws_instance" "alert-management-kafka-oracle-bastion-instance" {
	ami = var.ami
	availability_zone = "${var.region}a"
	associate_public_ip_address = true
	disable_api_termination = false
	hibernation = false
	instance_initiated_shutdown_behavior = "stop"
	instance_type = var.instance_type
	iam_instance_profile = var.iam_bastion_role
	key_name = var.key_pair
	placement_group = aws_placement_group.alert-management-kafka-oracle-placement-group.id
	security_groups = [aws_security_group.alert-management-kafka-oracle-bastion-securitygroup.id]
	subnet_id = aws_subnet.alert-management-kafka-oracle-subnet1.id
	tags = {
		Name = "alert-management-kafka-oracle-bastion-instance"
		Description = "Bastion instance"
		Version = "1.0"
	}
	user_data = file("./bastion-userdata.sh")
	connection {
		user = "ubuntu"
		private_key = file("./kafka-keypair.pem")
		timeout = "10m"
	}
}
output "bastion-instance-public-dns" {
	value = aws_instance.alert-management-kafka-oracle-bastion-instance.public_dns
}
output "bastion-instance-public-ip" {
	value = aws_instance.alert-management-kafka-oracle-bastion-instance.public_ip
}
