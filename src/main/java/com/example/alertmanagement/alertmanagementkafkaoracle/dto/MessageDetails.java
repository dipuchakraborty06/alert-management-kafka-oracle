package com.example.alertmanagement.alertmanagementkafkaoracle.dto;

import java.io.Serializable;
import java.util.UUID;

public class MessageDetails implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String messageCode = "";
	private String message = "";
	private String messageId = UUID.randomUUID().toString();
	private String messageOffset = "";
	
	public String getMessageId() {
		return messageId;
	}

	public MessageDetails(String messageCode, String message) {
		this.messageCode = messageCode;
		this.message = message;
	}

	public String getMessageOffset() {
		return messageOffset;
	}

	public void setMessageOffset(String messageOffset) {
		this.messageOffset = messageOffset;
	}

	public void setMessageId(String messageId) {
		this.messageId = messageId;
	}

	public String getMessageCode() {
		return messageCode;
	}

	public String getMessage() {
		return message;
	}

}
