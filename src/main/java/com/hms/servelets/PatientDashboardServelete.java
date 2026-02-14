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

@WebServlet("/PatientDashboardServelete")
public class PatientDashboardServelete extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // 1. Enhanced session validation
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("patientLogin.jsp?error=session_expired");
            return;
        }

        String username = (String) session.getAttribute("username");
        
        try (Connection conn = DBUtil.getConnection()) {
            // 2. Corrected SQL query to match your database schema
            String sql = "SELECT id, username, name, dob, address, phone FROM patients WHERE username = ?";
            
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // 3. Properly construct Patient object with all fields
                        Patient patient = new Patient();
                        patient.setId(rs.getInt("id"));
                        patient.setUsername(rs.getString("username"));
                        patient.setName(rs.getString("name"));
                        
                        // 4. Handle possible null values for date
                        java.sql.Date dob = rs.getDate("dob");
                        patient.setDob(dob != null ? new Date(dob.getTime()) : null);
                        
                        patient.setAddress(rs.getString("address"));
                        patient.setPhone(rs.getString("phone"));
                        
                        // 5. Set attributes before forwarding
                        request.setAttribute("patient", patient);
                        
                        // 6. Add any additional required attributes
                        request.setAttribute("currentDate", new Date());
                        
                        request.getRequestDispatcher("patientDashboard.jsp").forward(request, response);
                    } else {
                        session.invalidate();
                        response.sendRedirect("patientLogin.jsp?error=patient_not_found");
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.invalidate();
            // 7. More specific error handling
            response.sendRedirect("patientLogin.jsp?error=database_error&message=" + 
                URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }
}