<%@ page import="java.sql.*, java.time.*, java.time.format.DateTimeFormatter" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, com.hms.util.DBUtil" %>
<%
    String username = (String) session.getAttribute("username");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String name = "", address = "", phone = "", dob = "";
    int age = 0;

    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement("SELECT name, dob, address, phone FROM patients WHERE username = ?")) {
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            dob = rs.getString("dob");
            address = rs.getString("address");
            phone = rs.getString("phone");

            if (dob != null) {
                LocalDate birthDate = LocalDate.parse(dob);
                age = Period.between(birthDate, LocalDate.now()).getYears();
            }
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }

    // Handle update
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String newName = request.getParameter("name");
        String newDob = request.getParameter("dob");
        String newAddress = request.getParameter("address");
        String newPhone = request.getParameter("phone");

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("UPDATE patients SET name=?, dob=?, address=?, phone=? WHERE username=?")) {
            ps.setString(1, newName);
            ps.setString(2, newDob);
            ps.setString(3, newAddress);
            ps.setString(4, newPhone);
            ps.setString(5, username);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("patientProfile.jsp");
            }
        } catch (Exception e) {
            out.println("<p style='color:red;'>Update Error: " + e.getMessage() + "</p>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Patient Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #6c63ff;
            --primary-light: #8a85ff;
            --secondary: #ff6584;
            --dark: #2d3748;
            --light: #f7fafc;
            --success: #48bb78;
            --error: #f56565;
            --warning: #ed8936;
            --gray: #e2e8f0;
            --text: #4a4a4a;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #e4e8f0 100%);
            min-height: 100vh;
            padding: 2rem;
            color: var(--text);
        }
        
        .container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            position: relative;
        }
        
        .back-btn {
            display: inline-flex;
            align-items: center;
            padding: 0.6rem 1.2rem;
            background-color: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
            box-shadow: 0 2px 5px rgba(108, 99, 255, 0.2);
            margin-bottom: 1.5rem;
        }
        
        .back-btn:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(108, 99, 255, 0.3);
        }
        
        .back-btn i {
            margin-right: 8px;
        }
        
        h2 {
            text-align: center;
            color: var(--primary);
            margin-bottom: 1.5rem;
            font-size: 2rem;
            position: relative;
        }
        
        h2::after {
            content: '';
            display: block;
            width: 80px;
            height: 4px;
            background: var(--secondary);
            margin: 0.5rem auto;
            border-radius: 2px;
        }
        
        .profile-form {
            margin-top: 1.5rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--primary-dark);
            font-size: 0.95rem;
        }
        
        input[type="text"], 
        input[type="date"],
        input[type="number"] {
            width: 100%;
            padding: 0.8rem 1rem;
            border: 2px solid var(--gray);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        input[readonly] {
            background-color: rgba(108, 99, 255, 0.05);
            color: var(--text);
        }
        
        input:focus {
            border-color: var(--primary-light);
            outline: none;
            box-shadow: 0 0 0 3px rgba(108, 99, 255, 0.1);
        }
        
        .submit-btn {
            display: block;
            width: 100%;
            padding: 0.9rem;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(108, 99, 255, 0.2);
            margin-top: 1.5rem;
        }
        
        .submit-btn:hover {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--primary) 100%);
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(108, 99, 255, 0.3);
        }
        
        .submit-btn i {
            margin-right: 8px;
        }
        
        .error-message {
            background-color: rgba(245, 101, 101, 0.1);
            color: var(--error);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
        }
        
        .error-message i {
            margin-right: 10px;
        }
        
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            
            .container {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="patientDashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>
        
        <h2>Your Profile</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getParameter("error") %>
            </div>
        <% } %>
        
        <form method="post" class="profile-form">
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" value="<%= name %>" required />
            </div>
            
            <div class="form-group">
                <label for="dob">Date of Birth</label>
                <input type="date" id="dob" name="dob" value="<%= dob %>" required />
            </div>
            
            <div class="form-group">
                <label for="age">Age</label>
                <input type="text" id="age" value="<%= age %>" readonly />
            </div>
            
            <div class="form-group">
                <label for="phone">Phone Number</label>
                <input type="text" id="phone" name="phone" value="<%= phone %>" required />
            </div>
            
            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" value="<%= address %>" required />
            </div>
            
            <button type="submit" class="submit-btn">
                <i class="fas fa-save"></i> Update Profile
            </button>
        </form>
    </div>
</body>
</html>