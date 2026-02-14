package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static String URL;
    private static String USER;
    private static String PASSWORD;
    
    static {
        // First priority: Railway's native MySQL variables
        String mysqlHost = System.getenv("MYSQLHOST");
        String mysqlPort = System.getenv("MYSQLPORT");
        String mysqlDatabase = System.getenv("MYSQL_DATABASE");
        String mysqlUser = System.getenv("MYSQLUSER");
        String mysqlPassword = System.getenv("MYSQLPASSWORD");
        
        if (mysqlHost != null && mysqlUser != null && mysqlPassword != null) {
            USER = mysqlUser;
            PASSWORD = mysqlPassword;
            URL = "jdbc:mysql://" + mysqlHost + ":" + mysqlPort + "/" + mysqlDatabase +
                  "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&rewriteBatchedStatements=true";
            System.out.println("Database URL configured from Railway native variables");
            System.out.println("Host: " + mysqlHost + ":" + mysqlPort);
            System.out.println("Database: " + mysqlDatabase);
        }
        // Second priority: DATABASE_URL format
        else if (System.getenv("DATABASE_URL") != null) {
            try {
                String dbUrl = System.getenv("DATABASE_URL");
                System.out.println("Parsing DATABASE_URL: " + dbUrl);
                
                String cleanUrl = dbUrl.replace("mysql://", "");
                int atIndex = cleanUrl.indexOf('@');
                String credentials = cleanUrl.substring(0, atIndex);
                String hostAndDb = cleanUrl.substring(atIndex + 1);
                
                String[] userPass = credentials.split(":");
                USER = userPass[0];
                PASSWORD = userPass[1];
                
                int slashIndex = hostAndDb.indexOf('/');
                String hostPort = hostAndDb.substring(0, slashIndex);
                String database = hostAndDb.substring(slashIndex + 1);
                
                URL = "jdbc:mysql://" + hostPort + "/" + database +
                      "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&rewriteBatchedStatements=true";
                System.out.println("Database URL configured from DATABASE_URL");
            } catch (Exception e) {
                System.err.println("Error parsing DATABASE_URL: " + e.getMessage());
                e.printStackTrace();
                setLocalDefaults();
            }
        } else {
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
            System.out.println("URL: " + URL);
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Database connected successfully!");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found", e);
        } catch (SQLException e) {
            System.err.println("❌ Connection failed!");
            System.err.println("URL: " + URL);
            System.err.println("User: " + USER);
            System.err.println("Error: " + e.getMessage());
            throw e;
        }
    }
}