#################### Create Bastion instance ##########################
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
	user_data = file("./scripts/bastion-userdata.sh")
  	depends_on = [aws_security_group.alert-management-kafka-oracle-bastion-securitygroup,aws_placement_group.alert-management-kafka-oracle-placement-group]
}
resource "time_sleep" "wait_15_minutes" {
	depends_on = [aws_instance.alert-management-kafka-oracle-bastion-instance]
  	create_duration = "15m"
}
resource "aws_ami_from_instance" "alert-management-kafka-oracle-ami" {
  name               = "alert-management-kafka-oracle-ami"
  source_instance_id = aws_instance.alert-management-kafka-oracle-bastion-instance.id
  snapshot_without_reboot = true
  depends_on = [time_sleep.wait_15_minutes]
  tags = {
  	Name = "alert-management-kafka-oracle-ami"
  }
}