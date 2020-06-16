#################### Provision Kafka cluster ##########################
resource "null_resource" "provision-kafka1" {
	provisioner "remote-exec" {
		connection {
			host = aws_instance.alert-management-kafka-oracle-kafka-instance1.private_ip
			bastion_host = aws_instance.alert-management-kafka-oracle-bastion-instance.public_ip
			bastion_user = "ubuntu"
			bastion_private_key = file("./kafka-keypair.pem")
			type = "ssh"
			user = "ubuntu"
			private_key = file("./kafka-keypair.pem")
			timeout = "20m"
		}
	    inline = [
	      "sudo sed -i 's/broker.id=0/broker.id=1/g' /opt/kafka/config/server.properties",
		  "sudo hostnamectl set-hostname kafka-server1",
		  "sudo systemctl start zookeeper",
		  "sudo systemctl enable zookeeper",
		  "sudo sleep 1m",
	      "sudo sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=${aws_elb.alert-management-kafka-oracle-zookeeper-elb.dns_name}:2181/g' /opt/kafka/config/server.properties",
	      "sudo sed -i 's/localhost/${aws_instance.alert-management-kafka-oracle-kafka-instance1.private_ip}/g' /opt/kafka/config/server.properties",
	      "sudo sed -i 's/bootstrap.servers=localhost:9092/bootstrap.servers=${aws_elb.alert-management-kafka-oracle-kafka-elb.dns_name}:9092/g' /opt/kafka/config/producer.properties",
	      "sudo sed -i 's/bootstrap.servers=localhost:9092/bootstrap.servers=${aws_elb.alert-management-kafka-oracle-kafka-elb.dns_name}:9092/g' /opt/kafka/config/consumer.properties",
	      "sudo systemctl start kafka",
	      "sudo systemctl enable kafka"
	    ]
  	}
	depends_on = [
		aws_elb.alert-management-kafka-oracle-zookeeper-elb,
		aws_elb.alert-management-kafka-oracle-kafka-elb
	]
}
resource "null_resource" "provision-kafka2" {
	provisioner "remote-exec" {
		connection {
			host = aws_instance.alert-management-kafka-oracle-kafka-instance2.private_ip
			bastion_host = aws_instance.alert-management-kafka-oracle-bastion-instance.public_ip
			bastion_user = "ubuntu"
			bastion_private_key = file("./kafka-keypair.pem")
			type = "ssh"
			user = "ubuntu"
			private_key = file("./kafka-keypair.pem")
			timeout = "20m"
		}
	    inline = [
	      "sudo sed -i 's/broker.id=0/broker.id=2/g' /opt/kafka/config/server.properties",
		  "sudo hostnamectl set-hostname kafka-server2",
		  "sudo systemctl start zookeeper",
		  "sudo systemctl enable zookeeper",
		  "sudo sleep 1m",
	      "sudo sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=${aws_elb.alert-management-kafka-oracle-zookeeper-elb.dns_name}:2181/g' /opt/kafka/config/server.properties",
	      "sudo sed -i 's/localhost/${aws_instance.alert-management-kafka-oracle-kafka-instance2.private_ip}/g' /opt/kafka/config/server.properties",
	      "sudo sed -i 's/bootstrap.servers=localhost:9092/bootstrap.servers=${aws_elb.alert-management-kafka-oracle-kafka-elb.dns_name}:9092/g' /opt/kafka/config/producer.properties",
	      "sudo sed -i 's/bootstrap.servers=localhost:9092/bootstrap.servers=${aws_elb.alert-management-kafka-oracle-kafka-elb.dns_name}:9092/g' /opt/kafka/config/consumer.properties",
	      "sudo systemctl start kafka",
	      "sudo systemctl enable kafka"
	    ]
  	}
	depends_on = [
		aws_elb.alert-management-kafka-oracle-zookeeper-elb,
		aws_elb.alert-management-kafka-oracle-kafka-elb
	]
}
resource "null_resource" "provision-kafka3" {
	provisioner "remote-exec" {
		connection {
			host = aws_instance.alert-management-kafka-oracle-kafka-instance3.private_ip
			bastion_host = aws_instance.alert-management-kafka-oracle-bastion-instance.public_ip
			bastion_user = "ubuntu"
			bastion_private_key = file("./kafka-keypair.pem")
			type = "ssh"
			user = "ubuntu"
			private_key = file("./kafka-keypair.pem")
			timeout = "20m"
		}
	    inline = [
	      "sudo sed -i 's/broker.id=0/broker.id=3/g' /opt/kafka/config/server.properties",
		  "sudo hostnamectl set-hostname kafka-server3",
		  "sudo systemctl start zookeeper",
		  "sudo systemctl enable zookeeper",
		  "sudo sleep 1m",
	      "sudo sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=${aws_elb.alert-management-kafka-oracle-zookeeper-elb.dns_name}:2181/g' /opt/kafka/config/server.properties",
	      "sudo sed -i 's/localhost/${aws_instance.alert-management-kafka-oracle-kafka-instance3.private_ip}/g' /opt/kafka/config/server.properties",
	      "sudo sed -i 's/bootstrap.servers=localhost:9092/bootstrap.servers=${aws_elb.alert-management-kafka-oracle-kafka-elb.dns_name}:9092/g' /opt/kafka/config/producer.properties",
	      "sudo sed -i 's/bootstrap.servers=localhost:9092/bootstrap.servers=${aws_elb.alert-management-kafka-oracle-kafka-elb.dns_name}:9092/g' /opt/kafka/config/consumer.properties",
	      "sudo systemctl start kafka",
	      "sudo systemctl enable kafka"
	    ]
  	}
	depends_on = [
		aws_elb.alert-management-kafka-oracle-zookeeper-elb,
		aws_elb.alert-management-kafka-oracle-kafka-elb
	]
}
###################### Create Kafka topic #####################################################
resource "time_sleep" "wait_1_minute" {
	depends_on = [null_resource.provision-kafka1,null_resource.provision-kafka2,null_resource.provision-kafka3]
  	create_duration = "1m"
}
resource "null_resource" "set-server-host-file" {
	provisioner "remote-exec" {
		connection {
			host = aws_instance.alert-management-kafka-oracle-bastion-instance.public_ip
			type = "ssh"
			user = "ubuntu"
			private_key = file("./kafka-keypair.pem")
			timeout = "20m"
		}
	    inline = [
	      "sudo echo \"kafka-server1	${aws_instance.alert-management-kafka-oracle-kafka-instance1.private_ip}\" >> /etc/hosts",
	      "sudo echo \"kafka-server2	${aws_instance.alert-management-kafka-oracle-kafka-instance2.private_ip}\" >> /etc/hosts",
	      "sudo echo \"kafka-server3	${aws_instance.alert-management-kafka-oracle-kafka-instance3.private_ip}\" >> /etc/hosts"
	    ]
  	}
	depends_on = [time_sleep.wait_1_minute]
}
resource "null_resource" "create-topic-alert-data-feed" {
	provisioner "remote-exec" {
		connection {
			host = aws_instance.alert-management-kafka-oracle-kafka-instance1.private_ip
			bastion_host = aws_instance.alert-management-kafka-oracle-bastion-instance.public_ip
			bastion_user = "ubuntu"
			bastion_private_key = file("./kafka-keypair.pem")
			type = "ssh"
			user = "ubuntu"
			private_key = file("./kafka-keypair.pem")
			timeout = "20m"
		}
	    inline = [
	      "sudo /opt/kafka/bin/kafka-topics.sh --create --bootstrap-server ${aws_instance.alert-management-kafka-oracle-kafka-instance1.private_ip}:9092 --replication-factor 3 --partitions 3 --topic ${var.kafka-topic-name}"
	    ]
  	}
	depends_on = [time_sleep.wait_1_minute]
}
