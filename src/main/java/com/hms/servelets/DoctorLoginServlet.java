package com.hms.servelets;

import com.hms.util.DBUtil;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DoctorLoginServlet")
public class DoctorLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try (Connection con = DBUtil.getConnection()) {
            String query = "SELECT * FROM doctors WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Get doctor name from "doctor" column
                String doctorName = rs.getString("doctor");

                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                session.setAttribute("doctor", doctorName);
// Store doctor's name in session

                response.sendRedirect("DoctorDashboard");
            } else {
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid email or password!');");
                out.println("location='doctorLogin.jsp';");
                out.println("</script>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3>Something went wrong: " + e.getMessage() + "</h3>");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("doctorLogin.jsp");
    }
}
