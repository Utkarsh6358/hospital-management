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

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("=== Doctor Login Attempt ===");
        System.out.println("Email: " + email);

        try (Connection con = DBUtil.getConnection()) {
            System.out.println("Database connection successful");
            
            String query = "SELECT * FROM doctors WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String doctorName = rs.getString("doctor");
                System.out.println("Doctor found: " + doctorName);

                HttpSession session = request.getSession(true);
                session.setAttribute("email", email);
                session.setAttribute("doctor", doctorName);
                session.setMaxInactiveInterval(30 * 60); // 30 minutes timeout
                
                System.out.println("Session created, redirecting to DoctorDashboard");
                response.sendRedirect("DoctorDashboard");
            } else {
                System.out.println("No doctor found with these credentials");
                response.setContentType("text/html");
                PrintWriter out = response.getWriter();
                out.println("<script type=\"text/javascript\">");
                out.println("alert('Invalid email or password!');");
                out.println("location='doctorLogin.jsp';");
                out.println("</script>");
            }

        } catch (Exception e) {
            System.out.println("ERROR in DoctorLoginServlet: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h3>Something went wrong: " + e.getMessage() + "</h3>");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect("doctorLogin.jsp");
    }
}