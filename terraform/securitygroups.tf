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
	egress {
		description = "Any outbound traffic"
    	from_port   = 0
    	to_port     = 0
    	protocol    = "-1"
    	cidr_blocks = ["0.0.0.0/0"]
  	}
	depends_on = [aws_vpc.alert-management-kafka-oracle-vpc]
	tags = {
		Name = "alert-management-kafka-oracle-bastion-securitygroup"
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
	depends_on = [aws_vpc.alert-management-kafka-oracle-vpc]
  	tags = {
    	Name = "alert-management-kafka-oracle-kafka-securitygroup"
  	}
}