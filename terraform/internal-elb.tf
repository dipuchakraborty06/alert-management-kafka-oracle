############### Create internal elb for zookeeper and kafka server #########################
resource "aws_elb" "alert-management-kafka-oracle-zookeeper-elb" {
	name = "zookeeper-elb"
	security_groups = [aws_security_group.alert-management-kafka-oracle-kafka-securitygroup.id]
	subnets = [
		aws_subnet.alert-management-kafka-oracle-subnet1.id,
		aws_subnet.alert-management-kafka-oracle-subnet2.id,
		aws_subnet.alert-management-kafka-oracle-subnet3.id
	]
	instances = [
		aws_instance.alert-management-kafka-oracle-kafka-instance1.id,
		aws_instance.alert-management-kafka-oracle-kafka-instance2.id,
		aws_instance.alert-management-kafka-oracle-kafka-instance3.id
	]
	internal = true
  	listener {
    	instance_port      = 2181
    	instance_protocol  = "tcp"
    	lb_port            = 2181
    	lb_protocol        = "tcp"
  	}
	health_check {
    	healthy_threshold   = 2
    	unhealthy_threshold = 2
    	timeout             = 3
    	target              = "tcp:2181"
    	interval            = 30
  	}
  	cross_zone_load_balancing   = true
  	idle_timeout                = 400
  	connection_draining         = true
  	connection_draining_timeout = 400
  	tags = {
    	Name = "alert-management-kafka-oracle-zookeeper-elb"
  	}
}
resource "aws_elb" "alert-management-kafka-oracle-kafka-elb" {
	name = "kafka-elb"
	security_groups = [aws_security_group.alert-management-kafka-oracle-kafka-securitygroup.id]
	subnets = [
		aws_subnet.alert-management-kafka-oracle-subnet1.id,
		aws_subnet.alert-management-kafka-oracle-subnet2.id,
		aws_subnet.alert-management-kafka-oracle-subnet3.id
	]
	instances = [
		aws_instance.alert-management-kafka-oracle-kafka-instance1.id,
		aws_instance.alert-management-kafka-oracle-kafka-instance2.id,
		aws_instance.alert-management-kafka-oracle-kafka-instance3.id
	]
	internal = true
  	listener {
    	instance_port      = 9092
    	instance_protocol  = "tcp"
    	lb_port            = 9092
    	lb_protocol        = "tcp"
  	}
	health_check {
    	healthy_threshold   = 2
    	unhealthy_threshold = 2
    	timeout             = 3
    	target              = "tcp:9092"
    	interval            = 30
  	}
  	cross_zone_load_balancing   = true
  	idle_timeout                = 400
  	connection_draining         = true
  	connection_draining_timeout = 400
  	tags = {
    	Name = "alert-management-kafka-oracle-kafka-elb"
  	}
}