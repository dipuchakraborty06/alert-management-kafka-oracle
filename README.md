# alert-management-kafka-oracle

This project/re-useable code asset depicts the architecture for laying out Kafka cluster, 
creating JWT based REST services with Lambda and API Gateway to expose the same to internet.

# Used technology stack - 
1. Spring Boots for Kafka wrapper service creation - Kafka topic producer and consumer using SASL for
   authentication mechanism.
2. Ansible, Terraform for AWS infrastructure automation as code.
3. AWS Lambda serverless platform for Spring boots code run and expose JWT based REST service.
4. AWS API Gateway for Lambda REST service expose to internet
 
# Kafka architecture layout -
![Kafka Architecture]("https://github.com/dipuchakraborty06/alert-management-kafka-oracle/kafka-architecture.png")

# Steps for AWS based Kafka infrastructure layout using ansible and terraform - 
  --> Please edit terraform/variables.tf file to set desired region where the infrastructure will spin-up.
      This file will also contains role names for Bastion instance and Kafka instances, Kafka topic to create etc. 
  --> Please run the following command to create the Kafka infrastructure 
      ansible-playbook -i ansible/hosts /ansible/create-architecture.yml -e "@terraform_credentials.json"
      
      The credential file terraform crredentials should have AWS user secret key id and secret access key in the following format - 
      {
        "accessKeyId": "<AWS Access key ID>",
        "secretAccessKey": "<AWS secret access key>"
      }
      
  --> Please run the following command to tear-down/destroy the Kafka infrastructure - 
      ansible-playbook -i ansible/hosts ansible/destroy-architecture.yml -e "@terraform_credentials.json"  
