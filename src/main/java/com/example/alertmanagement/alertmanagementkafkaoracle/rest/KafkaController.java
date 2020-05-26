package com.example.alertmanagement.alertmanagementkafkaoracle.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.alertmanagement.alertmanagementkafkaoracle.dto.AlertMessage;
import com.example.alertmanagement.alertmanagementkafkaoracle.dto.ResponseMessage;

@RestController
@RequestMapping(value = "/kafka")
public class KafkaController {
	@Autowired
	private KafkaTemplate<String, AlertMessage> kafkaJsonTemplate;
	private String TOPIC = "alert-data-feed";
	
	@ResponseBody
	@PostMapping(value = "/postalert", consumes = {"application/json"}, produces = {"application/json"})
	public ResponseMessage postAlert(@RequestBody AlertMessage alertMessage){
		ResponseMessage responseMessage = new ResponseMessage();
		ListenableFuture<SendResult<String, AlertMessage>> listenableFuture = kafkaJsonTemplate.send(TOPIC, alertMessage);
		listenableFuture.addCallback(new ListenableFutureCallback<SendResult<String, AlertMessage>>() {
			@Override
			public void onSuccess(SendResult<String, AlertMessage> result) {
				responseMessage.setErrorCode("0000"); 
				responseMessage.setErrorMessage("Message send success");
				responseMessage.setMessageId(result.getProducerRecord().value().getMessageDetails().getMessageId().toString());
				responseMessage.setMessageOffset(Long.toString(result.getRecordMetadata().offset()));
				
			}
			@Override
			public void onFailure(Throwable ex) {
				responseMessage.setErrorCode("9999-postAlert"); 
				responseMessage.setErrorMessage(ex.getMessage());
				responseMessage.setMessageId("NA");
				responseMessage.setMessageOffset("NA");
				
			}
		});
		return responseMessage;
	}
	
	@ResponseBody
	@GetMapping(value = "/infoservice", produces = {"application/json"})
	public ResponseMessage infoService()
	{
		ResponseMessage responseMessage = new ResponseMessage();
		responseMessage.setErrorCode("0000"); 
		responseMessage.setErrorMessage("Alert Management Kafka wrapper service running successfully!!");
		
		return responseMessage;
	}
}
