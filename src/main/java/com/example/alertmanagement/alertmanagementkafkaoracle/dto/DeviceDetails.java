package com.example.alertmanagement.alertmanagementkafkaoracle.dto;

import java.io.Serializable;

public class DeviceDetails implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String deviceId;
	private String deviceName;
	private String deviceInterface;
	private String deviceLocatorLatitude;
	private String deviceLocatorLongitude;
	
	public String getDeviceId() {
		return deviceId;
	}
	public String getDeviceName() {
		return deviceName;
	}
	public String getDeviceInterface() {
		return deviceInterface;
	}
	public String getDeviceLocatorLatitude() {
		return deviceLocatorLatitude;
	}
	public String getDeviceLocatorLongitude() {
		return deviceLocatorLongitude;
	}
	
	public DeviceDetails(String deviceId, String deviceName, String deviceInterface, String deviceLocatorLatitude,String deviceLocatorLongitude){
		this.deviceId = deviceId;
		this.deviceName = deviceName;
		this.deviceInterface = deviceInterface;
		this.deviceLocatorLatitude = deviceLocatorLatitude;
		this.deviceLocatorLongitude = deviceLocatorLongitude;
	}
}
