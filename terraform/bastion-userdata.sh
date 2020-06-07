#!/bin/bash
# Title:				Amazon Ubuntu Bastion instance setup script
# Description:			Sets up a new Bastion ec2 instance
# Author:				Dipankar Chakraborty
# Last Updated:			June 06, 2020

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "################### Setting up Bastion server ########################"
apt-get update
apt-get install -y openjdk-8-jdk docker.io ansible

echo "#################### Installed Java version ###########################"
java -version
echo "################### Installed Docker version ##########################"
docker -version
usermod -aG docker ubuntu
systemctl start docker
systemctl enable docker
echo "############# Installing Jenkins for build automation #################"
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
sh -c 'echo deb http://pkg.jenkins-ci.org/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update
apt install -y jenkins
systemctl start jenkins
systemctl enable jenkins
ufw allow 8080
ufw status
echo "#######################################################################"

export INSTANCE_IP=`curl -s http://169.254.169.254/latest/meta-data/local-ipv4`