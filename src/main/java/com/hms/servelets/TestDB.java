package com.hms.servelets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class TestDB
 */
@WebServlet("/TestDB")
public class TestDB extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Connection conn = com.hms.util.DBUtil.getConnection();
            response.getWriter().println("✅ Connected to the database successfully!");
            conn.close();
        } catch (Exception e) {
            response.getWriter().println("❌ Database connection failed: " + e.getMessage());
        }
    }
}
