<%@ page import="java.sql.*, com.hms.util.DBUtil" %>
<%@ page session="true" %>

<%
// Handle delete request
if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("deleteId") != null) {
    int patientId = 0;
    try {
        patientId = Integer.parseInt(request.getParameter("deleteId"));
        try (Connection conn = DBUtil.getConnection()) {
            boolean exists = false;
            String checkSql = "SELECT id FROM patients WHERE id = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, patientId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    exists = rs.next();
                }
            }
            
            if (exists) {
                String deleteSql = "DELETE FROM patients WHERE id = ?";
                try (PreparedStatement deleteStmt = conn.prepareStatement(deleteSql)) {
                    deleteStmt.setInt(1, patientId);
                    int rowsAffected = deleteStmt.executeUpdate();
                    if (rowsAffected > 0) {
                        session.setAttribute("successMessage", "Patient deleted successfully!");
                    }
                }
            } else {
                session.setAttribute("errorMessage", "Patient not found!");
            }
        }
    } catch (Exception e) {
        session.setAttribute("errorMessage", "Error: " + e.getMessage());
    }
    response.sendRedirect("viewPatients.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management | HMS</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #4361ee;
            --secondary: #3f37c9;
            --accent: #4cc9f0;
            --success: #4ade80;
            --danger: #f87171;
            --warning: #fbbf24;
            --dark: #1e293b;
            --light: #f8fafc;
            --gray: #94a3b8;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f1f5f9;
            color: var(--dark);
            line-height: 1.6;
        }
        
        .container {
            max-width: 1400px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .card {
            background: white;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        .title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--primary);
        }
        
        .btn-group {
            display: flex;
            gap: 0.75rem;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 0.375rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
            border: none;
        }
        
        .btn i {
            font-size: 0.9rem;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--secondary);
            transform: translateY(-1px);
        }
        
        .btn-success {
            background-color: var(--success);
            color: white;
        }
        
        .btn-success:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        
        .btn-danger {
            background-color: var(--danger);
            color: white;
        }
        
        .btn-danger:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }
        
        .alert {
            padding: 1rem;
            border-radius: 0.375rem;
            margin: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .alert-success {
            background-color: #dcfce7;
            color: #166534;
            border-left: 4px solid var(--success);
        }
        
        .alert-error {
            background-color: #fee2e2;
            color: #991b1b;
            border-left: 4px solid var(--danger);
        }
        
        .table-container {
            overflow-x: auto;
            padding: 0 1.5rem 1.5rem;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
        }
        
        th {
            background-color: var(--primary);
            color: white;
            padding: 1rem;
            text-align: left;
            font-weight: 600;
        }
        
        td {
            padding: 1rem;
            border-bottom: 1px solid #e2e8f0;
        }
        
        tr:nth-child(even) {
            background-color: #f8fafc;
        }
        
        tr:hover {
            background-color: #f1f5f9;
        }
        
        .actions {
            display: flex;
            gap: 0.5rem;
        }
        
        .action-btn {
            padding: 0.375rem 0.75rem;
            border-radius: 0.25rem;
            font-size: 0.875rem;
        }
        
        .badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .badge-success {
            background-color: #dcfce7;
            color: #166534;
        }
        
        .search-bar {
            display: flex;
            gap: 0.75rem;
            padding: 0 1.5rem 1rem;
        }
        
        .search-input {
            flex: 1;
            padding: 0.5rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.375rem;
            font-size: 1rem;
        }
        
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .btn-group {
                width: 100%;
                justify-content: space-between;
            }
            
            th, td {
                padding: 0.75rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="card">
            <div class="header">
                <h1 class="title">
                    <i class="fas fa-user-injured"></i> Patient Management
                </h1>
                <div class="btn-group">
                    <a href="DoctorDashboard" class="btn btn-primary">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                    <button class="btn btn-success" onclick="window.location.reload()">
                        <i class="fas fa-sync-alt"></i> Refresh
                    </button>
                </div>
            </div>
            
            <% if (session.getAttribute("successMessage") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= session.getAttribute("successMessage") %>
                </div>
                <% session.removeAttribute("successMessage"); %>
            <% } %>
            
            <% if (session.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= session.getAttribute("errorMessage") %>
                </div>
                <% session.removeAttribute("errorMessage"); %>
            <% } %>
            
            <div class="search-bar">
                <input type="text" class="search-input" placeholder="Search patients..." id="searchInput">
                <button class="btn btn-primary">
                    <i class="fas fa-search"></i> Search
                </button>
            </div>
            
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Username</th>
                            <th>Date of Birth</th>
                            <th>Contact</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection conn = DBUtil.getConnection();
                             PreparedStatement stmt = conn.prepareStatement("SELECT * FROM patients ORDER BY name");
                             ResultSet rs = stmt.executeQuery()) {
                            
                            while (rs.next()) {
                                String dob = rs.getDate("dob") != null ? rs.getDate("dob").toString() : "N/A";
                        %>
                        <tr>
                            <td>#<%= rs.getInt("id") %></td>
                            <td>
                                <strong><%= rs.getString("name") %></strong>
                                <div class="text-muted"><%= rs.getString("address") %></div>
                            </td>
                            <td><%= rs.getString("username") %></td>
                            <td><%= dob %></td>
                            <td>
                                <i class="fas fa-phone"></i> <%= rs.getString("phone") %>
                            </td>
                            <td>
                                <span class="badge badge-success">
                                    <i class="fas fa-check"></i> Active
                                </span>
                            </td>
                            <td>
                                <div class="actions">
                                    <a href="editPatient.jsp?id=<%= rs.getInt("id") %>" class="btn btn-primary action-btn">
                                        <i class="fas fa-edit"></i> Edit
                                    </a>
                                    <form method="POST" style="display:inline;">
                                        <input type="hidden" name="deleteId" value="<%= rs.getInt("id") %>">
                                        <button type="submit" class="btn btn-danger action-btn" 
                                                onclick="return confirm('Are you sure you want to delete <%= rs.getString("name") %>?')">
                                            <i class="fas fa-trash-alt"></i> Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                        %>
                        <tr>
                            <td colspan="7" style="color: var(--danger); padding: 1rem;">
                                <i class="fas fa-exclamation-triangle"></i> Error loading patients: <%= e.getMessage() %>
                            </td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        // Simple search functionality
        document.getElementById('searchInput').addEventListener('input', function() {
            const searchValue = this.value.toLowerCase();
            const rows = document.querySelectorAll('tbody tr');
            
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchValue) ? '' : 'none';
            });
        });
    </script>
</body>
</html>