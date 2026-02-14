package com.hms.dao;

import com.hms.model.Patient;
import com.hms.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {
    
    public Patient getPatientByUsername(String username) throws SQLException {
        String sql = "SELECT * FROM patients WHERE username = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setId(rs.getInt("id"));
                    patient.setUsername(rs.getString("username"));
                    patient.setName(rs.getString("name"));
                    patient.setDob(rs.getDate("dob"));
                    patient.setAddress(rs.getString("address"));
                    patient.setPhone(rs.getString("phone"));
                    return patient;
                }
            }
        }
        return null;
    }

    public boolean updatePatient(Patient patient) throws SQLException {
        String sql = "UPDATE patients SET name=?, dob=?, address=?, phone=? WHERE username=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, patient.getName());
            stmt.setDate(2, new java.sql.Date(patient.getDob().getTime()));
            stmt.setString(3, patient.getAddress());
            stmt.setString(4, patient.getPhone());
            stmt.setString(5, patient.getUsername());
            
            return stmt.executeUpdate() > 0;
        }
    }

	public static List<Patient> readPatients(String patientsPath) {
		// TODO Auto-generated method stub
		return null;
	}

	public static void writePatients(String patientsPath, List<Patient> patients) {
		// TODO Auto-generated method stub
		
	}
}