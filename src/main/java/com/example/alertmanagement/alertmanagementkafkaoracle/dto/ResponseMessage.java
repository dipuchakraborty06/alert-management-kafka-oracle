package com.example.alertmanagement.alertmanagementkafkaoracle.dto;

import java.io.Serializable;

public class ResponseMessage implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String errorCode = "";
	private String errorMessage = "";
	private MessageDetails messageDetails;
	
	public MessageDetails getMessageDetails() {
		return messageDetails;
	}

	public void setMessageDetails(MessageDetails messageDetails) {
		this.messageDetails = messageDetails;
	}

	public String getErrorCode() {
		return errorCode;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public ResponseMessage() {
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

}
