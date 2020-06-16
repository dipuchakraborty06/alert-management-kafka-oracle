#!/bin/bash
# Title:				Amazon Ubuntu Bastion instance setup script
# Description:			Sets up a new Bastion ec2 instance
# Author:				Dipankar Chakraborty
# Last Updated:			June 06, 2020

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "################### Setting up Bastion server - installing required packages ########################"
apt-get update
apt-get install -y openjdk-8-jdk docker.io ansible unzip awscli

echo "#################### Installed Java version ###########################"
java -version

echo "################### Installed Docker version ##########################"
docker version
usermod -aG docker ubuntu
systemctl start docker
systemctl enable docker
aws s3 get s3://dipuchakraborty06.alertmanagementkafkaoracle/docker_credential
docker login --username dipuchakraborty06 --password-stdin < docker_credential
rm docker_credential

echo "################## Installed Ansible version ##########################"
ansible --version

echo "############# Installing Kafka and configuring the same ###############"
mkdir /opt/kafka
mkdir /opt/kafka/data
chown -R ubuntu:ubuntu /opt/kafka

wget http://apachemirror.wuchna.com/kafka/2.5.0/kafka_2.12-2.5.0.tgz
mv kafka_2.12-2.5.0.tgz /opt/kafka
tar -xvzf /opt/kafka/kafka_2.12-2.5.0.tgz --directory /opt/kafka --strip-components 1
rm -rf /opt/kafka/kafka_2.12-2.5.0.tgz
aws s3 sync s3://dipuchakraborty06.alertmanagementkafkaoracle/ /opt/kafka/config
sed -i "s/KAFKA_HEAP_OPTS=\"-Xmx512M -Xms512M\"/KAFKA_HEAP_OPTS=\"-Xmx256M -Xms256M -Djava.security.auth.login.config=\/opt\/kafka\/config\/zookeeper_jaas.conf\"/g" /opt/kafka/bin/zookeeper-server-start.sh
sed -i "s/KAFKA_HEAP_OPTS=\"-Xmx1G -Xms1G\"/KAFKA_HEAP_OPTS=\"-Xmx256M -Xms256M -Djava.security.auth.login.config=\/opt\/kafka\/config\/server_jaas.conf\"/g" /opt/kafka/bin/kafka-server-start.sh

sed -i "s/dataDir=\/tmp\/zookeeper/dataDir=\/tmp\/zookeeper/g" /opt/kafka/config/zookeeper.properties
echo "authProvider.1=org.apache.zookeeper.server.auth.SASLAuthenticationProvider" >> /opt/kafka/config/zookeeper.properties
echo "requireClientAuthScheme=sasl" >> /opt/kafka/config/zookeeper.properties
echo "jaasLoginRenew=3600000" >> /opt/kafka/config/zookeeper.properties

echo "security.protocol=SASL_PLAINTEXT" >> /opt/kafka/config/producer.properties
echo "sasl.mechanism=PLAIN" >> /opt/kafka/config/producer.properties

sed -i "s/group.id=test-consumer-group/group.id=alert-management-kafka-oracle-consumer-group/g" /opt/kafka/config/consumer.properties
echo "security.protocol=SASL_PLAINTEXT" >> /opt/kafka/config/consumer.properties
echo "sasl.mechanism=PLAIN" >> /opt/kafka/config/consumer.properties

sed -i "s/log.dirs=\/tmp\/kafka-logs/log.dirs=\/opt\/kafka\/data/g" /opt/kafka/config/server.properties
sed -i "s/#listeners=PLAINTEXT:\/\/:9092/listeners=SASL_PLAINTEXT:\/\/localhost:9092/g" /opt/kafka/config/server.properties
sed -i "s/#advertised.listeners=PLAINTEXT:\/\/your.host.name:9092/advertised.listeners=SASL_PLAINTEXT:\/\/localhost:9092/g" /opt/kafka/config/server.properties
echo "auto.create.topics.enable=false" >> /opt/kafka/config/server.properties
echo "delete.topic.enable=true" >> /opt/kafka/config/server.properties
echo "sasl.enabled.mechanisms=PLAIN" >> /opt/kafka/config/server.properties
echo "security.inter.broker.protocol=SASL_PLAINTEXT" >> /opt/kafka/config/server.properties
echo "sasl.mechanism.inter.broker.protocol=PLAIN" >> /opt/kafka/config/server.properties
echo "authorizer.class.name=kafka.security.auth.SimpleAclAuthorizer" >> /opt/kafka/config/server.properties
echo "allow.everyone.if.no.acl.found=false" >> /opt/kafka/config/server.properties

echo "[Unit]" >> /etc/systemd/system/zookeeper.service
echo "Requires=network.target remote-fs.target" >> /etc/systemd/system/zookeeper.service
echo "After=network.target remote-fs.target" >> /etc/systemd/system/zookeeper.service
echo "[Service]" >> /etc/systemd/system/zookeeper.service
echo "Type=simple" >> /etc/systemd/system/zookeeper.service
echo "User=ubuntu" >> /etc/systemd/system/zookeeper.service
echo "ExecStart=/opt/kafka/bin/zookeeper-server-start.sh /opt/kafka/config/zookeeper.properties" >> /etc/systemd/system/zookeeper.service
echo "ExecStop=/opt/kafka/bin/zookeeper-server-stop.sh" >> /etc/systemd/system/zookeeper.service
echo "Restart=on-abnormal"  >> /etc/systemd/system/zookeeper.service
echo "[Install]" >> /etc/systemd/system/zookeeper.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/zookeeper.service

echo "[Unit]" >> /etc/systemd/system/kafka.service
echo "Requires=zookeeper.service" >> /etc/systemd/system/kafka.service
echo "After=zookeeper.service" >> /etc/systemd/system/kafka.service
echo "[Service]" >> /etc/systemd/system/kafka.service
echo "Type=simple" >> /etc/systemd/system/kafka.service
echo "User=ubuntu" >> /etc/systemd/system/kafka.service
echo "ExecStart=/bin/sh -c '/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /opt/kafka/kafka.log 2>&1'" >> /etc/systemd/system/kafka.service
echo "ExecStop=/opt/kafka/bin/kafka-server-stop.sh" >> /etc/systemd/system/kafka.service
echo "Restart=on-abnormal"  >> /etc/systemd/system/kafka.service
echo "[Install]" >> /etc/systemd/system/kafka.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/kafka.service

echo "################ Setting IPs as variable ##############################"
export INSTANCE_PRIVATE_IP=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`
export INSTANCE_PUBLIC_IP=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`
export INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
echo "Private IP - $INSTANCE_PRIVATE_IP and Public IP - $INSTANCE_PUBLIC_IP"
hostnamectl set-hostname kafka-bastion-server