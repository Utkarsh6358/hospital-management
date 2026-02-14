<%@ page import="java.sql.*, com.hms.util.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Handle deletion
    String deleteId = request.getParameter("deleteId");
    if (deleteId != null) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM feedback WHERE id = ?")) {
            ps.setInt(1, Integer.parseInt(deleteId));
            ps.executeUpdate();
        } catch (Exception e) {
            out.println("<div class='error-message'>Error deleting feedback: " + e.getMessage() + "</div>");
        }
    }
%>
<html>
<head>
    <title>View Feedback</title>
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
            color: var(--dark);
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 2rem;
            border-radius: 16px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
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
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
            overflow: hidden;
            border-radius: 12px;
        }
        
        th, td {
            padding: 1rem 1.5rem;
            text-align: left;
            border-bottom: 1px solid var(--gray);
        }
        
        th {
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
            color: white;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        
        tr:nth-child(even) {
            background-color: rgba(108, 99, 255, 0.03);
        }
        
        tr:hover {
            background-color: rgba(108, 99, 255, 0.05);
        }
        
        .delete-btn {
            color: white;
            background: linear-gradient(135deg, var(--error) 0%, #ff4757 100%);
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 500;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            box-shadow: 0 2px 5px rgba(245, 101, 101, 0.2);
        }
        
        .delete-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(245, 101, 101, 0.3);
        }
        
        .delete-btn i {
            margin-right: 6px;
        }
        
        .error-message {
            background-color: rgba(245, 101, 101, 0.1);
            color: var(--error);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            border-left: 4px solid var(--error);
            display: flex;
            align-items: center;
        }
        
        .error-message i {
            margin-right: 10px;
        }
        
        .feedback-text {
            max-width: 400px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        
        .timestamp {
            color: var(--dark);
            font-size: 0.9rem;
        }
        
        .username {
            font-weight: 500;
            color: var(--primary-dark);
        }
        
        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            
            .container {
                padding: 1rem;
            }
            
            th, td {
                padding: 0.75rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <a href="DoctorDashboard" class="back-btn">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
            <h2>Patient Feedback Management</h2>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>Patient</th>
                    <th>Feedback</th>
                    <th>Date</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                try (Connection conn = DBUtil.getConnection();
                     Statement stmt = conn.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT id, username, feedback_text, submitted_at FROM feedback ORDER BY submitted_at DESC")) {

                    while (rs.next()) {
                        int id = rs.getInt("id");
                        String username = rs.getString("username");
                        String feedbackText = rs.getString("feedback_text");
                        Timestamp submittedAt = rs.getTimestamp("submitted_at");
            %>
                <tr>
                    <td class="username"><%= username %></td>
                    <td class="feedback-text"><%= feedbackText %></td>
                    <td class="timestamp"><%= new java.text.SimpleDateFormat("MMM dd, yyyy hh:mm a").format(submittedAt) %></td>
                    <td>
                        <form method="post" style="display:inline;">
                            <input type="hidden" name="deleteId" value="<%= id %>"/>
                            <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this feedback?');">
                                <i class="fas fa-trash-alt"></i> Delete
                            </button>
                        </form>
                    </td>
                </tr>
            <%
                    }
                } catch (Exception e) {
            %>
                <tr>
                    <td colspan="4" class="error-message">
                        <i class="fas fa-exclamation-circle"></i> Error: <%= e.getMessage() %>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</body>
</html>