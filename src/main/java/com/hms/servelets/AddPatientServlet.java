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

@WebServlet("/AddPatientServlet")
public class AddPatientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String dob = request.getParameter("dob");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        try (Connection conn = DBUtil.getConnection()) {
            // Add to users table
            String userSql = "INSERT INTO users (username, password, role) VALUES (?, ?, 'patient')";
            try (PreparedStatement userStmt = conn.prepareStatement(userSql)) {
                userStmt.setString(1, username);
                userStmt.setString(2, password);
                userStmt.executeUpdate();
            }

            // Add to patients table
            String patientSql = "INSERT INTO patients (username, name, dob, address, phone) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement patientStmt = conn.prepareStatement(patientSql)) {
                patientStmt.setString(1, username);
                patientStmt.setString(2, name);
                patientStmt.setString(3, dob);
                patientStmt.setString(4, address);
                patientStmt.setString(5, phone);
                patientStmt.executeUpdate();
            }

            response.sendRedirect("DoctorDashboardServlet");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}