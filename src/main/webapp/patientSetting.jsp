<%@ page import="java.sql.*, com.hms.util.DBUtil" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("patientLogin.jsp");
        return;
    }

    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement getPatient = conn.prepareStatement("SELECT password FROM patients WHERE username = ?");
        ) {
            getPatient.setString(1, username);
            ResultSet rs = getPatient.executeQuery();

            if (rs.next()) {
                String currentPassword = rs.getString("password");

                if (!oldPassword.equals(currentPassword)) {
                    message = "Old password is incorrect!";
                } else if (!newPassword.equals(confirmPassword)) {
                    message = "New passwords do not match!";
                } else {
                    PreparedStatement updateStmt = conn.prepareStatement(
                        "UPDATE patients SET name = ?, address = ?, phone = ?, password = ? WHERE username = ?"
                    );
                    updateStmt.setString(1, name);
                    updateStmt.setString(2, address);
                    updateStmt.setString(3, phone);
                    updateStmt.setString(4, newPassword);
                    updateStmt.setString(5, username);

                    int updated = updateStmt.executeUpdate();
                    if (updated > 0) {
                        message = "Settings updated successfully!";
                    } else {
                        message = "Update failed!";
                    }

                    updateStmt.close();
                }
            }
            rs.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }

    // Load current patient data
    String name = "", address = "", phone = "";
    try (
        Connection conn = DBUtil.getConnection();
        PreparedStatement stmt = conn.prepareStatement("SELECT name, address, phone FROM patients WHERE username = ?");
    ) {
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            address = rs.getString("address");
            phone = rs.getString("phone");
        }
        rs.close();
    } catch (Exception e) {
        message = "Error loading patient info: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Patient Settings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        
        .back-btn {
            display: inline-flex;
            align-items: center;
            padding: 8px 15px;
            background-color: #4a6baf;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        
        .back-btn:hover {
            background-color: #3a5a9f;
        }
        
        .back-btn i {
            margin-right: 5px;
        }
        
        h2 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 20px;
        }
        
        .card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }
        
        input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            transition: border-color 0.3s;
        }
        
        input:focus {
            border-color: #4a6baf;
            outline: none;
        }
        
        .divider {
            border: 0;
            height: 1px;
            background-color: #eee;
            margin: 25px 0;
        }
        
        .btn {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: #4a6baf;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        
        .btn:hover {
            background-color: #3a5a9f;
        }
        
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
            text-align: center;
            font-weight: 500;
        }
        
        .success {
            background-color: #d4edda;
            color: #155724;
        }
        
        .error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="patientDashboard.jsp" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            <h2>Account Settings</h2>
        </div>

        <% if (!message.isEmpty()) { %>
            <div class="message <%= message.contains("success") ? "success" : "error" %>">
                <%= message %>
            </div>
        <% } %>

        <div class="card">
            <form method="post">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" value="<%= name %>" required />
                </div>
                
                <div class="form-group">
                    <label for="address">Address</label>
                    <input type="text" id="address" name="address" value="<%= address %>" required />
                </div>
                
                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" value="<%= phone %>" required />
                </div>
                
                <hr class="divider">
                
                <h3 style="margin-bottom: 15px; color: #2c3e50;">Change Password</h3>
                
                <div class="form-group">
                    <label for="oldPassword">Current Password</label>
                    <input type="password" id="oldPassword" name="oldPassword" required />
                </div>
                
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" required />
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required />
                </div>
                
                <button type="submit" class="btn">
                    <i class="fas fa-save"></i> Save Changes
                </button>
            </form>
        </div>
    </div>
</body>
</html>