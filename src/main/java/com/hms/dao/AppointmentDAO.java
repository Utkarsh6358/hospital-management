package com.hms.dao;

import com.hms.model.Appointment;
import com.hms.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {
    
    public List<Appointment> getAppointmentsByPatient(String username) throws SQLException {
        List<Appointment> appointments = new ArrayList<>();
        String sql = "SELECT a.*, d.specialization FROM appointments a " +
                     "JOIN doctors d ON a.doctor = d.doctor " +
                     "WHERE a.username = ? ORDER BY a.appointment_date DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Appointment appointment = new Appointment();
                    appointment.setId(rs.getInt("id"));
                    appointment.setUsername(rs.getString("username"));
                    appointment.setDoctor(rs.getString("doctor"));
                    appointment.setAppointmentDate(rs.getDate("appointment_date"));
                    appointment.setAppointmentTime(rs.getTime("appointment_time"));
                    appointment.setReason(rs.getString("reason"));
                    appointments.add(appointment);
                }
            }
        }
        return appointments;
    }

    public boolean createAppointment(Appointment appointment) throws SQLException {
        String sql = "INSERT INTO appointments (username, doctor, appointment_date, " +
                     "appointment_time, reason) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, appointment.getUsername());
            stmt.setString(2, appointment.getDoctor());
            stmt.setDate(3, new java.sql.Date(appointment.getAppointmentDate().getTime()));
            stmt.setTime(4, new java.sql.Time(appointment.getAppointmentTime().getTime()));
            stmt.setString(5, appointment.getReason());
            
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean cancelAppointment(int appointmentId) throws SQLException {
        String sql = "DELETE FROM appointments WHERE id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, appointmentId);
            return stmt.executeUpdate() > 0;
        }
    }
}