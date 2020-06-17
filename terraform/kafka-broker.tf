#################### Create Kafka instances with zookeeper and broker ##########################
resource "aws_instance" "alert-management-kafka-oracle-kafka-instance1" {
	ami = aws_ami_from_instance.alert-management-kafka-oracle-ami.id
	availability_zone = "${var.region}a"
	associate_public_ip_address = false
	disable_api_termination = false
	hibernation = false
	instance_initiated_shutdown_behavior = "stop"
	instance_type = var.instance_type
	iam_instance_profile = var.iam_kafka_role
	key_name = var.key_pair
	placement_group = aws_placement_group.alert-management-kafka-oracle-placement-group.id
	security_groups = [aws_security_group.alert-management-kafka-oracle-kafka-securitygroup.id]
	subnet_id = aws_subnet.alert-management-kafka-oracle-subnet1.id
	tags = {
		Name = "alert-management-kafka-oracle-kafka-instance1"
		Description = "Kafka Zookeeper/Broker instance 1"
		Version = "1.0"
	}
	depends_on = [
		aws_ami_from_instance.alert-management-kafka-oracle-ami,
		aws_security_group.alert-management-kafka-oracle-kafka-securitygroup
	]
}
resource "aws_instance" "alert-management-kafka-oracle-kafka-instance2" {
	ami = aws_ami_from_instance.alert-management-kafka-oracle-ami.id
	availability_zone = "${var.region}b"
	associate_public_ip_address = false
	disable_api_termination = false
	hibernation = false
	instance_initiated_shutdown_behavior = "stop"
	instance_type = var.instance_type
	iam_instance_profile = var.iam_kafka_role
	key_name = var.key_pair
	placement_group = aws_placement_group.alert-management-kafka-oracle-placement-group.id
	security_groups = [aws_security_group.alert-management-kafka-oracle-kafka-securitygroup.id]
	subnet_id = aws_subnet.alert-management-kafka-oracle-subnet2.id
	tags = {
		Name = "alert-management-kafka-oracle-kafka-instance2"
		Description = "Kafka Zookeeper/Broker instance 2"
		Version = "1.0"
	}
	depends_on = [
		aws_ami_from_instance.alert-management-kafka-oracle-ami,
		aws_security_group.alert-management-kafka-oracle-kafka-securitygroup
	]
}
resource "aws_instance" "alert-management-kafka-oracle-kafka-instance3" {
	ami = aws_ami_from_instance.alert-management-kafka-oracle-ami.id
	availability_zone = "${var.region}c"
	associate_public_ip_address = false
	disable_api_termination = false
	hibernation = false
	instance_initiated_shutdown_behavior = "stop"
	instance_type = var.instance_type
	iam_instance_profile = var.iam_kafka_role
	key_name = var.key_pair
	placement_group = aws_placement_group.alert-management-kafka-oracle-placement-group.id
	security_groups = [aws_security_group.alert-management-kafka-oracle-kafka-securitygroup.id]
	subnet_id = aws_subnet.alert-management-kafka-oracle-subnet3.id
	tags = {
		Name = "alert-management-kafka-oracle-kafka-instance3"
		Description = "Kafka Zookeeper/Broker instance 3"
		Version = "1.0"
	}
	depends_on = [
		aws_ami_from_instance.alert-management-kafka-oracle-ami,
		aws_security_group.alert-management-kafka-oracle-kafka-securitygroup
	]
}