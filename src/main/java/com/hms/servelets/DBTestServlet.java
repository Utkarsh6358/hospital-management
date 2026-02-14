# Create the test servlet
@"
package com.hms.servelets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/db-test")
public class DBTestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><body>");
        out.println("<h2>Database Connection Test</h2>");
        
        // Show environment variables
        out.println("<h3>Environment Variables:</h3>");
        out.println("<ul>");
        out.println("<li>MYSQLHOST: " + System.getenv("MYSQLHOST") + "</li>");
        out.println("<li>MYSQLPORT: " + System.getenv("MYSQLPORT") + "</li>");
        out.println("<li>MYSQL_DATABASE: " + System.getenv("MYSQL_DATABASE") + "</li>");
        out.println("<li>MYSQLUSER: " + System.getenv("MYSQLUSER") + "</li>");
        out.println("<li>MYSQLPASSWORD: " + (System.getenv("MYSQLPASSWORD") != null ? "SET" : "NOT SET") + "</li>");
        out.println("<li>DATABASE_URL: " + System.getenv("DATABASE_URL") + "</li>");
        out.println("</ul>");
        
        // Try to connect
        out.println("<h3>Connection Attempt:</h3>");
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            out.println("<p style='color:green'>✓ MySQL JDBC Driver loaded</p>");
            
            String host = System.getenv("MYSQLHOST");
            String port = System.getenv("MYSQLPORT");
            String db = System.getenv("MYSQL_DATABASE");
            String user = System.getenv("MYSQLUSER");
            String password = System.getenv("MYSQLPASSWORD");
            
            if (host != null && user != null && password != null) {
                String url = "jdbc:mysql://" + host + ":" + port + "/" + db +
                             "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
                
                out.println("<p>Connecting with: " + url + "</p>");
                
                Connection conn = DriverManager.getConnection(url, user, password);
                out.println("<p style='color:green'>✓ Connected successfully!</p>");
                
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM patients");
                if (rs.next()) {
                    out.println("<p>Patients count: " + rs.getInt("count") + "</p>");
                }
                conn.close();
            } else {
                out.println("<p style='color:red'>✗ Missing environment variables</p>");
            }
            
        } catch (Exception e) {
            out.println("<p style='color:red'>✗ Error: " + e.getMessage() + "</p>");
            e.printStackTrace(response.getWriter());
        }
        
        out.println("</body></html>");
    }
}
"@ | Out-File -FilePath "src/main/java/com/hms/servelets/DBTestServlet.java" -Encoding UTF8