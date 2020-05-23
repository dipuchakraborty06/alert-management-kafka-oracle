package com.example.alertmanagement.alertmanagementkafkaoracle.dto;

import java.io.Serializable;

public class MessageDetails implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String messageCode;
	private String message;
	
	public MessageDetails(String messageCode, String message) {
		this.messageCode = messageCode;
		this.message = message;
	}

	public String getMessageCode() {
		return messageCode;
	}

	public String getMessage() {
		return message;
	}

}
