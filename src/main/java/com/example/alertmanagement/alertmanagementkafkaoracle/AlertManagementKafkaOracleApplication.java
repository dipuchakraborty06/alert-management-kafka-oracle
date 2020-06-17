package com.example.alertmanagement.alertmanagementkafkaoracle;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.Import;

import com.example.alertmanagement.alertmanagementkafkaoracle.rest.KafkaController;

@SpringBootApplication
@Import({ KafkaController.class })
public class AlertManagementKafkaOracleApplication extends SpringBootServletInitializer{

	public static void main(String[] args) {
		SpringApplication.run(AlertManagementKafkaOracleApplication.class, args);
	}

}
