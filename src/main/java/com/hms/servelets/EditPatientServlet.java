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

import com.hms.model.Patient;
import com.hms.util.DBUtil;

@WebServlet("/EditPatientServlet")
public class EditPatientServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("id");

        try (Connection conn = DBUtil.getConnection()) {
            String sql = "SELECT * FROM patients WHERE username = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    Patient patient = new Patient(
                        rs.getString("username"),
                        rs.getString("name"),
                        rs.getString("dob"),
                        rs.getString("address"),
                        rs.getString("phone")
                    );
                    request.setAttribute("patient", patient);
                    request.getRequestDispatcher("editPatient.jsp").forward(request, response);
                } else {
                    response.sendRedirect("DoctorDashboardServlet?error=Patient+not+found");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("DoctorDashboardServlet?error=Error+loading+patient");
        }
    }
}