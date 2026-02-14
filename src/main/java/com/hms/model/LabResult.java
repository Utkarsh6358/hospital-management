package com.hms.model;

//LabResult.java

public class LabResult {
private String testId;
private String testName;
private String date;
private String result;
private String doctorComments;
public LabResult() {
	super();
	
}
// Constructors, getters, setters
public String getTestId() {
	return testId;
}
public void setTestId(String testId) {
	this.testId = testId;
}
public String getTestName() {
	return testName;
}
public void setTestName(String testName) {
	this.testName = testName;
}
public String getDate() {
	return date;
}
public void setDate(String date) {
	this.date = date;
}
public String getResult() {
	return result;
}
public void setResult(String result) {
	this.result = result;
}
public String getDoctorComments() {
	return doctorComments;
}
public void setDoctorComments(String doctorComments) {
	this.doctorComments = doctorComments;
}
public LabResult(String testId, String testName, String date, String result, String doctorComments) {
	super();
	this.testId = testId;
	this.testName = testName;
	this.date = date;
	this.result = result;
	this.doctorComments = doctorComments;
}


}