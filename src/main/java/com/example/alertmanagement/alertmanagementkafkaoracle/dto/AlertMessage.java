package com.example.alertmanagement.alertmanagementkafkaoracle.dto;

import java.io.Serializable;

public class AlertMessage implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private LocationDetails locationDetails;
	private DeviceDetails deviceDetails;
	private MessageDetails messageDetails;
	
	public AlertMessage(LocationDetails locationDetails, DeviceDetails deviceDetails, MessageDetails messageDetails) {
		this.locationDetails = locationDetails;
		this.deviceDetails = deviceDetails;
		this.messageDetails = messageDetails;
	}

	public LocationDetails getLocationDetails() {
		return locationDetails;
	}

	public DeviceDetails getDeviceDetails() {
		return deviceDetails;
	}

	public MessageDetails getMessageDetails() {
		return messageDetails;
	}
	
}

