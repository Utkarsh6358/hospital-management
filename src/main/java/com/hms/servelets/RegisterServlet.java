package com.hms.servelets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.hms.util.DBUtil;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String dob = request.getParameter("dob");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        try (Connection conn = DBUtil.getConnection()) {
            // Check if username exists
            String checkSql = "SELECT * FROM patients WHERE username = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, username);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next()) {
                    request.setAttribute("error", "Username already exists");
                    request.getRequestDispatcher("register.jsp").forward(request, response);
                    return;
                }
            }

            // Hash the password before storing
            String plainPassword = password;


            // Add to patients table
            String patientSql = "INSERT INTO patients (username, password, name, dob, address, phone) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement patientStmt = conn.prepareStatement(patientSql)) {
                patientStmt.setString(1, username);
                patientStmt.setString(2, plainPassword);
                patientStmt.setString(3, name);
                java.sql.Date sqlDob = java.sql.Date.valueOf(dob); // Assumes format is yyyy-mm-dd
                patientStmt.setDate(4, sqlDob);
                patientStmt.setString(5, address);
                patientStmt.setString(6, phone);
                patientStmt.executeUpdate();
            }

            response.sendRedirect("patientLogin.jsp?registered=true");
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Registration failed: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }
}