// UserDAO.java
package com.hms.dao;

import com.hms.model.User;

import java.sql.*;

public class UserDAO {

    public static User validateUser(String username, String password) {
        User user = null;
        try {
            Connection conn = com.hms.util.DBUtil.getConnection();

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
