package com.hms.servelets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hms.util.DBUtil;

@WebServlet("/DeletePatientServlet")
public class DeletePatientServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("id");

        try (Connection conn = DBUtil.getConnection()) {
            // Delete from patients table
            String patientSql = "DELETE FROM patients WHERE username = ?";
            try (PreparedStatement patientStmt = conn.prepareStatement(patientSql)) {
                patientStmt.setString(1, username);
                patientStmt.executeUpdate();
            }

            // Delete from users table
            String userSql = "DELETE FROM users WHERE username = ?";
            try (PreparedStatement userStmt = conn.prepareStatement(userSql)) {
                userStmt.setString(1, username);
                userStmt.executeUpdate();
            }

            response.sendRedirect("DoctorDashboard?success=Patient+deleted+successfully");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("DoctorDashboard?error=Error+deleting+patient");
        }
    }
}