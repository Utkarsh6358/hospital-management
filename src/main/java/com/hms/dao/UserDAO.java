// UserDAO.java
package com.hms.dao;

import com.hms.model.User;

import java.sql.*;

public class UserDAO {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/your_db_name";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "your_password";

    public static User validateUser(String username, String password) {
        User user = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return user;
    }
}
