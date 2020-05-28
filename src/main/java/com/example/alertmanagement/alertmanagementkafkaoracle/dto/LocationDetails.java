package com.example.alertmanagement.alertmanagementkafkaoracle.dto;

import java.io.Serializable;

public class LocationDetails implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String region = "";
	private String country = "";
	private String state = "";
	private String county = "";
	private String area = "";
	private String address = "";
	private String zipCode = "";
	
	public String getRegion() {
		return region;
	}
	public String getCountry() {
		return country;
	}
	public String getState() {
		return state;
	}
	public String getCounty() {
		return county;
	}
	public String getArea() {
		return area;
	}
	public String getAddress() {
		return address;
	}
	public String getZipCode() {
		return zipCode;
	}
	
	public LocationDetails(String region, String country, String state, String county, String area, String address, String zipCode)
	{
		this.region = region;
		this.country = country;
		this.state = state;
		this.county = county;
		this.area = area;
		this.address = address;
		this.zipCode = zipCode;
	}

}
