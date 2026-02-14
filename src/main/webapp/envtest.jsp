<%@ page import="java.util.*,java.sql.*" %>
<html>
<head><title>Environment Test</title>
<style>
    body { font-family: Arial; margin: 20px; }
    table { border-collapse: collapse; width: 50%; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background-color: #4CAF50; color: white; }
    .success { color: green; }
    .error { color: red; font-weight: bold; }
</style>
</head>
<body>
<h2>🔍 Environment Variables</h2>
<table>
<tr><th>Variable</th><th>Value</th></tr>
<tr><td>MYSQLHOST</td><td><%= System.getenv("MYSQLHOST") %></td></tr>
<tr><td>MYSQLPORT</td><td><%= System.getenv("MYSQLPORT") %></td></tr>
<tr><td>MYSQL_DATABASE</td><td><%= System.getenv("MYSQL_DATABASE") %></td></tr>
<tr><td>MYSQLUSER</td><td><%= System.getenv("MYSQLUSER") %></td></tr>
<tr><td>MYSQLPASSWORD</td><td><%= System.getenv("MYSQLPASSWORD") != null ? "✅ SET" : "❌ NOT SET" %></td></tr>
<tr><td>DATABASE_URL</td><td><%= System.getenv("DATABASE_URL") %></td></tr>
</table>

<h2>🔌 Database Connection Test</h2>
<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    out.println("<p class='success'>✓ JDBC Driver loaded successfully</p>");
    
    String host = System.getenv("MYSQLHOST");
    String port = System.getenv("MYSQLPORT");
    String db = System.getenv("MYSQL_DATABASE");
    String user = System.getenv("MYSQLUSER");
    String password = System.getenv("MYSQLPASSWORD");
    
    // Print what we're using
    out.println("<p>Connecting with:</p>");
    out.println("<ul>");
    out.println("<li>Host: " + (host != null ? host : "mysql.railway.internal (default)") + "</li>");
    out.println("<li>Port: " + (port != null ? port : "3306 (default)") + "</li>");
    out.println("<li>Database: " + (db != null ? db : "railway (default)") + "</li>");
    out.println("<li>User: " + (user != null ? user : "root (default)") + "</li>");
    out.println("</ul>");
    
    // Use defaults if not set
    if (host == null) host = "mysql.railway.internal";
    if (port == null) port = "3306";
    if (db == null) db = "railway";
    if (user == null) user = "root";
    
    String url = "jdbc:mysql://" + host + ":" + port + "/" + db +
                 "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&connectTimeout=30000";
    out.println("<p>JDBC URL: <code>" + url + "</code></p>");
    
    Connection conn = DriverManager.getConnection(url, user, password);
    out.println("<p class='success'>✅ Connected to database successfully!</p>");
    
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM patients");
    if (rs.next()) {
        out.println("<p class='success'>✅ Patients table exists with <strong>" + rs.getInt("count") + "</strong> records</p>");
    }
    
    // Test another query
    rs = stmt.executeQuery("SELECT COUNT(*) as count FROM doctors");
    if (rs.next()) {
        out.println("<p class='success'>✅ Doctors table exists with <strong>" + rs.getInt("count") + "</strong> records</p>");
    }
    
    conn.close();
} catch (ClassNotFoundException e) {
    out.println("<p class='error'>❌ MySQL JDBC Driver not found: " + e.getMessage() + "</p>");
} catch (SQLException e) {
    out.println("<p class='error'>❌ SQL Error: " + e.getMessage() + "</p>");
    out.println("<p>This usually means the database connection details are incorrect or the database is not accessible.</p>");
    e.printStackTrace(new java.io.PrintWriter(out));
} catch (Exception e) {
    out.println("<p class='error'>❌ Error: " + e.getMessage() + "</p>");
    e.printStackTrace(new java.io.PrintWriter(out));
}
%>

<h2>📋 System Info</h2>
<ul>
<li>Java Version: <%= System.getProperty("java.version") %></li>
<li>OS: <%= System.getProperty("os.name") %></li>
<li>User: <%= System.getProperty("user.name") %></li>
</ul>
</body>
</html>
