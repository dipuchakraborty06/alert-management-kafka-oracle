package com.example.alertmanagement.alertmanagementkafkaoracle.dto;

import java.io.Serializable;

public class ResponseMessage implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String errorCode;
	private String errorMessage;
	private String messageOffset;
	private String messageId;
	
	public String getMessageId() {
		return messageId;
	}

	public void setMessageId(String messageId) {
		this.messageId = messageId;
	}

	public String getMessageOffset() {
		return messageOffset;
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

	public void setMessageOffset(String messageOffset) {
		this.messageOffset = messageOffset;
	}

}
