package com.example.alertmanagement.alertmanagementkafkaoracle.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.alertmanagement.alertmanagementkafkaoracle.dto.AlertMessage;

@RestController
@RequestMapping(value = "/kafka")
public class KafkaController {
	@Autowired
	private KafkaTemplate<String, AlertMessage> kafkaJsonTemplate;
	private String TOPIC = "alert-data-feed";
	
	@PostMapping(value = "/postAlert", consumes = {"application/json"}, produces = {"application/json"})
	public String postAlert(@RequestBody AlertMessage alertMessage){
		kafkaJsonTemplate.send(TOPIC, alertMessage);
		return "Message send successfully!!!";
	}
}
