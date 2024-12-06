package model;

import java.io.Serializable;

public class Station implements Serializable {
	private int stationID;
	private String stationName;
	private int stationTypeID;
	private double latitude;
    private double longitude;
    private int altitude;
    
    public Station() {
    	
    }
    
	public Station(int stationID, String stationName, int stationTypeID, double latitude, double longitude, int altitude) {
		this.stationID = stationID;
		this.stationName = stationName;
		this.stationTypeID = stationTypeID;
		this.latitude = latitude;
		this.longitude = longitude;
		this.altitude = altitude;
	}
	
	public int getStationID() {
		return stationID;
	}
	public void setStationID(int stationID) {
		this.stationID = stationID;
	}
	public String getStationName() {
		return stationName;
	}
	public void setStationName(String stationName) {
		this.stationName = stationName;
	}
	public int getStationTypeID() {
		return stationTypeID;
	}
	public void setStationTypeID(int stationTypeID) {
		this.stationTypeID = stationTypeID;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public int getAltitude() {
		return altitude;
	}
	public void setAltitude(int altitude) {
		this.altitude = altitude;
	}
}
