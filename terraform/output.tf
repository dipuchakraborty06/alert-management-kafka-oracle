output "bastion-instance-public-dns" {
	value = aws_instance.alert-management-kafka-oracle-bastion-instance.public_dns
}
output "bastion-instance-public-ip" {
	value = aws_instance.alert-management-kafka-oracle-bastion-instance.public_ip
}
output "alert-management-kafka-oracle-kafka-elb-dns" {
	value = aws_elb.alert-management-kafka-oracle-kafka-elb.dns_name
}