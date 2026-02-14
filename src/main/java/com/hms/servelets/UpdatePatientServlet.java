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

@WebServlet("/UpdatePatientServlet")
public class UpdatePatientServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String name = request.getParameter("name");
        String dob = request.getParameter("dob");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "UPDATE patients SET name = ?, dob = ?, address = ?, phone = ? WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, name);
                stmt.setString(2, dob);
                stmt.setString(3, address);
                stmt.setString(4, phone);
                stmt.setString(5, username);
                stmt.executeUpdate();
            }

            response.sendRedirect("DoctorDashboard?success=Patient+updated");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("DoctorDashboard?error=Error+saving+changes");
        }
    }
}