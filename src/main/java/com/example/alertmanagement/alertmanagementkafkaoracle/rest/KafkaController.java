package com.example.alertmanagement.alertmanagementkafkaoracle.rest;

import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
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
import com.example.alertmanagement.alertmanagementkafkaoracle.dto.MessageDetails;
import com.example.alertmanagement.alertmanagementkafkaoracle.dto.ResponseMessage;

@RestController
@RequestMapping(value = "/kafka")
public class KafkaController {
	
	@Autowired
	private KafkaTemplate<String, AlertMessage> kafkaJsonTemplate;
	
	@Value("${alertmanagement.kafka.topic}")
	private String TOPIC;
	
	@ResponseBody
	@PostMapping(value = "/postalert", consumes = {"application/json"}, produces = {"application/json"})
	public ResponseMessage postAlert(@RequestBody AlertMessage alertMessage){
		ResponseMessage responseMessage = new ResponseMessage();
		try
		{
			SendResult<String,AlertMessage> sendResult = kafkaJsonTemplate.send(TOPIC, alertMessage).get(10, TimeUnit.SECONDS);
			responseMessage.setErrorCode("0000-postalert");
			responseMessage.setErrorMessage("Message post to kafka topic - "+TOPIC+" success");
			MessageDetails messageDetails = new MessageDetails(sendResult.getProducerRecord().value().getMessageDetails().getMessageCode(), sendResult.getProducerRecord().value().getMessageDetails().getMessageCode());
			messageDetails.setMessageId(sendResult.getProducerRecord().value().getMessageDetails().getMessageId());
			messageDetails.setMessageOffset(Long.toString(sendResult.getRecordMetadata().offset()));
			responseMessage.setMessageDetails(messageDetails);
		}
		catch(Exception e)
		{
			responseMessage.setErrorCode("9999-postalert");
			responseMessage.setErrorMessage(e.getMessage());
			responseMessage.setMessageDetails(alertMessage.getMessageDetails());
		}
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
