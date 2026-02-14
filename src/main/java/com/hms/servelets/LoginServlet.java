package com.hms.servelets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.hms.util.DBUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        System.out.println("\n======================================");
        System.out.println("PATIENT LOGIN ATTEMPT - " + new java.util.Date());
        System.out.println("Username: '" + username + "'");
        System.out.println("Password: '" + password + "'");
        System.out.println("======================================\n");

        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("✓ Database connection successful");
            
            String sql = "SELECT * FROM patients WHERE username = ? AND password = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    System.out.println("✓ Patient found in database:");
                    System.out.println("  - ID: " + rs.getInt("id"));
                    System.out.println("  - Name: " + rs.getString("name"));
                    System.out.println("  - Username: " + rs.getString("username"));

                    HttpSession session = request.getSession(true);
                    session.setAttribute("username", username);
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                    
                    System.out.println("✓ Session created with ID: " + session.getId());
                    System.out.println("→ Redirecting to PatientDashboardServlet");
                    
                    response.sendRedirect("PatientDashboardServlet");
                } else {
                    System.out.println("✗ No patient found with these credentials");
                    response.sendRedirect("patientLogin.jsp?error=1");
                }
            }
        } catch (SQLException e) {
            System.out.println("✗ DATABASE ERROR: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error");
            request.getRequestDispatcher("patientLogin.jsp").forward(request, response);
        }
    }
}