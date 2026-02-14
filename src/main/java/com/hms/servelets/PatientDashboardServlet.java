package com.hms.servelets;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hms.model.Patient;
import com.hms.util.DBUtil;

@WebServlet("/PatientDashboardServlet")
public class PatientDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Debug logging
        System.out.println("=== PatientDashboardServlet Access ===");
        
        if (session == null || session.getAttribute("username") == null) {
            System.out.println("No valid session - redirecting to patientLogin.jsp");
            response.sendRedirect("patientLogin.jsp?error=session_expired");
            return;
        }

        String username = (String) session.getAttribute("username");
        System.out.println("Username from session: " + username);
        
        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("Database connected for PatientDashboard");
            
            String sql = "SELECT id, username, name, dob, address, phone FROM patients WHERE username = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        Patient patient = new Patient();
                        patient.setId(rs.getInt("id"));
                        patient.setUsername(rs.getString("username"));
                        patient.setName(rs.getString("name"));
                        
                        java.sql.Date dob = rs.getDate("dob");
                        patient.setDob(dob != null ? new Date(dob.getTime()) : null);
                        
                        patient.setAddress(rs.getString("address"));
                        patient.setPhone(rs.getString("phone"));
                        
                        request.setAttribute("patient", patient);
                        request.setAttribute("currentDate", new Date());
                        
                        System.out.println("Patient found: " + patient.getName());
                        request.getRequestDispatcher("patientDashboard.jsp").forward(request, response);
                    } else {
                        System.out.println("Patient not found for username: " + username);
                        session.invalidate();
                        response.sendRedirect("patientLogin.jsp?error=patient_not_found");
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
            session.invalidate();
            response.sendRedirect("patientLogin.jsp?error=database_error&message=" + 
                URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}