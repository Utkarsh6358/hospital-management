package com.hms.model;

import java.util.Date;

public class Activity {
    private int id;
    private String patientUsername;
    private String type;
    private String icon;
    private String title;
    private String description;
    private Date timestamp;

    // Constructors
    public Activity() {}

    public Activity(String patientUsername, String type, String icon, 
                   String title, String description) {
        this.patientUsername = patientUsername;
        this.type = type;
        this.icon = icon;
        this.title = title;
        this.description = description;
        this.timestamp = new Date();
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getPatientUsername() { return patientUsername; }
    public void setPatientUsername(String patientUsername) { this.patientUsername = patientUsername; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public Date getTimestamp() { return timestamp; }
    public void setTimestamp(Date timestamp) { this.timestamp = timestamp; }
}