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

@WebServlet("/AddLabResultServlet")
public class AddLabResultServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String username = request.getParameter("id");
        request.setAttribute("patientUsername", username);
        request.getRequestDispatcher("addLabResult.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String patientUsername = request.getParameter("patientUsername");
        String testName = request.getParameter("testName");
        String date = request.getParameter("date");
        String result = request.getParameter("result");
        String comments = request.getParameter("comments");
        
        String sql = "INSERT INTO lab_results (patient_username, test_name, test_date, result, comments) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, patientUsername);
            stmt.setString(2, testName);
            stmt.setDate(3, java.sql.Date.valueOf(date));
            stmt.setString(4, result);
            stmt.setString(5, comments);
            
            int rowsInserted = stmt.executeUpdate();
            
            if (rowsInserted > 0) {
                response.sendRedirect("DoctorDashboard?id=" + patientUsername + "&success=Lab+result+added");
            } else {
                response.sendRedirect("DoctorDashboard?error=Error+adding+lab+result");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("DoctorDashboard?error=Database+error:+" + e.getMessage());
        }
    }
}