package com.hms.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Map;

public class DBUtil {
    private static String URL;
    private static String USER;
    private static String PASSWORD;
    
    static {
        System.out.println("=================================");
        System.out.println("DBUtil Static Initialization");
        System.out.println("=================================");
        
        // Print all environment variables (filtered for security)
        System.out.println("Environment variables with MYSQL or DATABASE:");
        Map<String, String> env = System.getenv();
        for (String key : env.keySet()) {
            if (key.contains("MYSQL") || key.contains("DATABASE") || key.contains("JDBC")) {
                String value = env.get(key);
                if (key.contains("PASSWORD") && value != null) {
                    value = value.substring(0, Math.min(5, value.length())) + "...";
                }
                System.out.println("  " + key + " = " + value);
            }
        }
        
        // First priority: Railway's native MySQL variables
        String mysqlHost = System.getenv("MYSQLHOST");
        String mysqlPort = System.getenv("MYSQLPORT");
        String mysqlDatabase = System.getenv("MYSQL_DATABASE");
        String mysqlUser = System.getenv("MYSQLUSER");
        String mysqlPassword = System.getenv("MYSQLPASSWORD");
        
        System.out.println("\nChecking Railway native variables:");
        System.out.println("  MYSQLHOST: " + (mysqlHost != null ? mysqlHost : "NOT SET"));
        System.out.println("  MYSQLPORT: " + (mysqlPort != null ? mysqlPort : "NOT SET"));
        System.out.println("  MYSQL_DATABASE: " + (mysqlDatabase != null ? mysqlDatabase : "NOT SET"));
        System.out.println("  MYSQLUSER: " + (mysqlUser != null ? mysqlUser : "NOT SET"));
        System.out.println("  MYSQLPASSWORD: " + (mysqlPassword != null ? "SET" : "NOT SET"));
        
        if (mysqlHost != null && mysqlUser != null && mysqlPassword != null && mysqlDatabase != null) {
            USER = mysqlUser;
            PASSWORD = mysqlPassword;
            URL = "jdbc:mysql://" + mysqlHost + ":" + mysqlPort + "/" + mysqlDatabase +
                  "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&rewriteBatchedStatements=true";
            System.out.println("✅ Using Railway native variables");
            System.out.println("   Host: " + mysqlHost + ":" + mysqlPort);
            System.out.println("   Database: " + mysqlDatabase);
        }
        // Second priority: DATABASE_URL format
        else if (System.getenv("DATABASE_URL") != null) {
            try {
                String dbUrl = System.getenv("DATABASE_URL");
                System.out.println("\nParsing DATABASE_URL: " + dbUrl);
                
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
                System.out.println("✅ Using DATABASE_URL");
                System.out.println("   JDBC URL: " + URL.replace(PASSWORD, "****"));
            } catch (Exception e) {
                System.err.println("❌ Error parsing DATABASE_URL: " + e.getMessage());
                e.printStackTrace();
                setLocalDefaults();
            }
        } else {
            System.out.println("\nNo Railway variables found, using local defaults");
            setLocalDefaults();
        }
        System.out.println("=================================\n");
    }
    
    private static void setLocalDefaults() {
        URL = "jdbc:mysql://localhost:3306/sanjeevani?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
        USER = "root";
        PASSWORD = "nishigami";
        System.out.println("⚠️ Using local database configuration");
        System.out.println("   URL: " + URL);
    }
    
    public static Connection getConnection() throws SQLException {
        System.out.println("\n--- getConnection() called ---");
        System.out.println("URL: " + (URL != null ? URL.replace(PASSWORD, "****") : "null"));
        System.out.println("User: " + USER);
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✓ Driver loaded successfully");
            
            System.out.println("Attempting connection...");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("✅ Connection successful!");
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL JDBC Driver not found!");
            e.printStackTrace();
            throw new SQLException("MySQL JDBC Driver not found", e);
        } catch (SQLException e) {
            System.err.println("❌ Connection failed!");
            System.err.println("   URL: " + (URL != null ? URL.replace(PASSWORD, "****") : "null"));
            System.err.println("   User: " + USER);
            System.err.println("   Error: " + e.getMessage());
            System.err.println("   SQL State: " + e.getSQLState());
            System.err.println("   Error Code: " + e.getErrorCode());
            throw e;
        }
    }
}