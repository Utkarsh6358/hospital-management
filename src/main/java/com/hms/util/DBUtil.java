package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static String URL;
    private static String USER;
    private static String PASSWORD;
    
    static {
        // For Railway deployment
        if (System.getenv("DATABASE_URL") != null) {
            try {
                // Parse Railway's MySQL connection string
                // Format: mysql://user:password@host:port/database
                String dbUrl = System.getenv("DATABASE_URL");
                
                // Remove mysql:// prefix
                String cleanUrl = dbUrl.replace("mysql://", "");
                
                // Split into credentials and host/db parts
                int atIndex = cleanUrl.indexOf('@');
                String credentials = cleanUrl.substring(0, atIndex);
                String hostAndDb = cleanUrl.substring(atIndex + 1);
                
                // Split credentials into user and password
                String[] userPass = credentials.split(":");
                USER = userPass[0];
                PASSWORD = userPass[1];
                
                // Split host:port/database
                int slashIndex = hostAndDb.indexOf('/');
                String hostPort = hostAndDb.substring(0, slashIndex);
                String database = hostAndDb.substring(slashIndex + 1);
                
                // Split host and port
                String[] hostPortArray = hostPort.split(":");
                String host = hostPortArray[0];
                String port = hostPortArray.length > 1 ? hostPortArray[1] : "3306";
                
                // Construct JDBC URL
                URL = "jdbc:mysql://" + host + ":" + port + "/" + database + 
                      "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&rewriteBatchedStatements=true";
                
                System.out.println("Database URL configured for Railway");
            } catch (Exception e) {
                System.err.println("Error parsing DATABASE_URL: " + e.getMessage());
                e.printStackTrace();
                // Fallback to local
                setLocalDefaults();
            }
        } else {
            // Local development
            setLocalDefaults();
        }
    }
    
    private static void setLocalDefaults() {
        URL = "jdbc:mysql://localhost:3306/sanjeevani?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        USER = "root";
        PASSWORD = "nishigami";
        System.out.println("Using local database configuration");
    }
    
    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Connecting to database...");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connected successfully!");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found", e);
        } catch (SQLException e) {
            System.err.println("Connection failed!");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("Error: " + e.getMessage());
            throw e;
        }
    }
    
    public static void testConnection() {
        try (Connection conn = getConnection()) {
            System.out.println("✅ Database connection successful!");
            System.out.println("Database: " + conn.getMetaData().getDatabaseProductName());
            System.out.println("Version: " + conn.getMetaData().getDatabaseProductVersion());
        } catch (SQLException e) {
            System.err.println("❌ Connection failed:");
            e.printStackTrace();
        }
    }
}