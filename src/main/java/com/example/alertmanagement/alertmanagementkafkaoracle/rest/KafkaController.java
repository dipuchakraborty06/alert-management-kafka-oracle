package com.example.alertmanagement.alertmanagementkafkaoracle.rest;

import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.kafka.support.SendResult;
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
	
	@Value("${alertmanagement.kafka.topic.waitforacknowledgement}")
	private Long MESSAGE_PRODUCER_TIMEOUT;
	
	@ResponseBody
	@PostMapping(value = "/postalert", consumes = {"application/json"}, produces = {"application/json"})
	public ResponseMessage postAlert(@RequestBody AlertMessage alertMessage){
		ResponseMessage responseMessage = new ResponseMessage();
		try
		{
			SendResult<String,AlertMessage> sendResult = kafkaJsonTemplate.send(TOPIC, alertMessage).get(MESSAGE_PRODUCER_TIMEOUT, TimeUnit.SECONDS);
			responseMessage.setErrorCode("0000-postalert");
			responseMessage.setErrorMessage("Message post to kafka topic - "+TOPIC+" success");
			MessageDetails messageDetails = new MessageDetails(sendResult.getProducerRecord().value().getMessageDetails().getMessageCode(), sendResult.getProducerRecord().value().getMessageDetails().getMessage());
			messageDetails.setMessageId(sendResult.getProducerRecord().value().getMessageDetails().getMessageId());
			messageDetails.setMessageOffset(Long.toString(sendResult.getRecordMetadata().offset()));
			responseMessage.setMessageDetails(messageDetails);
			
			System.out.println(KafkaController.class
					          +": Message post to kafka topic - "+TOPIC+" success with message id - "
							  +sendResult.getProducerRecord().value().getMessageDetails().getMessageId()
							  +" and current message offset - "+sendResult.getRecordMetadata().offset());
		}
		catch (ExecutionException e) {
			responseMessage.setErrorCode("9999-postalert");
			responseMessage.setErrorMessage(e.getMessage());
			responseMessage.setMessageDetails(alertMessage.getMessageDetails());
			
			System.out.println(KafkaController.class
							  +": exception in method - "+e.getStackTrace()[0].getMethodName()
							  +" with exception cause - "
							  +e.getMessage());
			e.printStackTrace();
	    }
	    catch (TimeoutException | InterruptedException e) {
	    	responseMessage.setErrorCode("9999-postalert");
			responseMessage.setErrorMessage("Message send timeout or interrupted");
			responseMessage.setMessageDetails(alertMessage.getMessageDetails());
			
			System.out.println(KafkaController.class
					  +": exception in method - "+e.getStackTrace()[0].getMethodName()
					  +" with exception cause - "
					  +e.getMessage());
			e.printStackTrace();
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
