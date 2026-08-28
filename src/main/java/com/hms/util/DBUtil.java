package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBUtil {

    private static String URL;
    private static String USER;
    private static String PASSWORD;

    static {
        System.out.println("=================================");
        System.out.println("DBUtil Initialization");
        System.out.println("=================================");

        boolean configured = false;

        // 🌐 FIRST PRIORITY: ENV VARIABLES (for deployment on Render/Railway)
        try {
            String host = System.getenv("DB_HOST");
            String port = System.getenv("DB_PORT");
            String db = System.getenv("DB_NAME");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASSWORD");

            if (host != null && user != null && pass != null && db != null) {
                Class.forName("com.mysql.cj.jdbc.Driver");

                URL = "jdbc:mysql://" + host + ":" + port + "/" + db +
                        "?sslMode=REQUIRED&serverTimezone=UTC";

                USER = user;
                PASSWORD = pass;

                System.out.println("✅ Using ENV database config");

                Connection testConn = DriverManager.getConnection(URL, USER, PASSWORD);
                testConn.close();

                System.out.println("✅ ENV DB connection SUCCESS");
                configured = true;
            }

        } catch (Exception e) {
            System.out.println("❌ ENV DB failed: " + e.getMessage());
        }

        // 🧪 FINAL FALLBACK: LOCAL DATABASE
        if (!configured) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                URL = "jdbc:mysql://localhost:3306/sanjeevani" +
                        "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";

                USER = "root";
                PASSWORD = "root"; // change if needed

                System.out.println("⚠️ Using LOCAL database");

            } catch (Exception e) {
                System.out.println("❌ Local DB setup failed: " + e.getMessage());
            }
        }

        System.out.println("=================================\n");
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            System.out.println("Connecting to DB...");
            System.out.println("URL: " + URL);

            Connection conn;

            // SSL connection handling
            if (URL.contains("sslMode=REQUIRED")) {
                Properties props = new Properties();
                props.setProperty("user", USER);
                props.setProperty("password", PASSWORD);
                props.setProperty("sslMode", "REQUIRED");

                conn = DriverManager.getConnection(URL, props);
            } else {
                conn = DriverManager.getConnection(URL, USER, PASSWORD);
            }

            System.out.println("✅ Connection SUCCESS");
            return conn;

        } catch (Exception e) {
            System.err.println("❌ DB Connection FAILED");
            System.err.println("Error: " + e.getMessage());
            throw new SQLException(e);
        }
    }
}