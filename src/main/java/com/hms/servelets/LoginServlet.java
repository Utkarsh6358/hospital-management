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

        System.out.println("=== Patient Login Attempt ===");
        System.out.println("Username: " + username);

        try (Connection conn = DBUtil.getConnection()) {
            System.out.println("Database connection successful");
            
            String sql = "SELECT * FROM patients WHERE username = ? AND password = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    HttpSession session = request.getSession(true);
                    session.setAttribute("username", username);
                    session.setMaxInactiveInterval(30 * 60); // 30 minutes
                    
                    System.out.println("Login successful, redirecting to PatientDashboardServlet");
                    response.sendRedirect("PatientDashboardServlet");
                } else {
                    System.out.println("Invalid credentials for username: " + username);
                    response.sendRedirect("patientLogin.jsp?error=1");
                }
            }
        } catch (SQLException e) {
            System.out.println("Database error: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Database error");
            request.getRequestDispatcher("patientLogin.jsp").forward(request, response);
        }
    }
}