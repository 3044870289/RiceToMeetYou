package model;

import java.io.Serializable;
import java.util.Date;

/**
 * @author Uesuke
 *
 */
public class Administrator implements Serializable {
	private int producerID;
	private String pass;
	private String producerName;
	private int tel;
	private Date birthday;
	private String address;
	
	public Administrator() {
		
	}

	public Administrator(int producerID, String pass, String producerName, int tel, Date birthday, String address) {
		this.producerID = producerID;
		this.pass = pass;
		this.producerName = producerName;
		this.tel = tel;
		this.birthday = birthday;
		this.address = address;
	}

	// Getter と Setter メソッド
	public int getProducerID() {
		return producerID;
	}

	public void setProducerID(int producerID) {
		this.producerID = producerID;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public String getProducerName() {
		return producerName;
	}

	public void setProducerName(String producerName) {
		this.producerName = producerName;
	}

	public int getTel() {
		return tel;
	}

	public void setTel(int tel) {
		this.tel = tel;
	}

	public Date getBirthday() {
		return birthday;
	}

	public void setBirthday(Date birthday) {
		this.birthday = birthday;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
}
