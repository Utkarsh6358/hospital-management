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

@WebServlet("/BookAppointmentServlet")
public class BookAppointmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String doctor = request.getParameter("doctor");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String reason = request.getParameter("reason");

        try (Connection conn = DBUtil.getConnection()) {
            // Updated SQL query to match the new table structure
            String sql = "INSERT INTO appointments (username, doctor, appointment_date, appointment_time, reason) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                stmt.setString(2, doctor);
                stmt.setString(3, date);
                stmt.setString(4, time);
                stmt.setString(5, reason);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    request.getSession().setAttribute("successMessage", "Appointment booked successfully!");
                    response.sendRedirect("patientDashboard.jsp");
                } else {
                    request.getSession().setAttribute("errorMessage", "Failed to book appointment.");
                    response.sendRedirect("bookAppointment.jsp");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // More specific error handling for foreign key violations
            if (e.getSQLState().equals("23000")) { // Integrity constraint violation
                request.getSession().setAttribute("errorMessage", "Invalid username or doctor. Please check your details.");
            } else {
                request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
            }
            response.sendRedirect("bookAppointment.jsp");
        }
    }
}