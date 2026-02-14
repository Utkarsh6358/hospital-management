<%@ page import="java.sql.*, java.time.*, java.time.format.DateTimeFormatter" %>
<%@ page session="true" %>

<%@ page import="java.sql.*, com.hms.util.DBUtil" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String deleteIdParam = request.getParameter("deleteId");
    String successMessage = null;
    String errorMessage = null;

    // Handle deletion if deleteId is provided
    if (deleteIdParam != null) {
        try {
            int deleteId = Integer.parseInt(deleteIdParam);
            try (Connection delConn = DBUtil.getConnection();
                 PreparedStatement delStmt = delConn.prepareStatement(
                     "DELETE FROM appointments WHERE id = ? AND username = ?")) {
                delStmt.setInt(1, deleteId);
                delStmt.setString(2, username);
                int rowsAffected = delStmt.executeUpdate();
                if (rowsAffected > 0) {
                    successMessage = "Appointment cancelled successfully!";
                } else {
                    errorMessage = "No appointment found to cancel.";
                }
            }
        } catch (Exception e) {
            errorMessage = "Failed to cancel appointment: " + e.getMessage();
        }
    }

    // Get the next appointment for countdown
    String nextAppointmentTime = null;
    String nextAppointmentDoctor = null;
    String nextAppointmentReason = null;
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement stmt = conn.prepareStatement(
             "SELECT a.*, d.specialization FROM appointments a " +
             "JOIN doctors d ON a.doctor = d.doctor " +
             "WHERE a.username = ? AND a.appointment_date >= CURDATE() " +
             "ORDER BY a.appointment_date, a.appointment_time LIMIT 1")) {
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            nextAppointmentTime = rs.getDate("appointment_date") + " " + rs.getTime("appointment_time");
            nextAppointmentDoctor = rs.getString("doctor") + " (" + rs.getString("specialization") + ")";
            nextAppointmentReason = rs.getString("reason");
        }
        rs.close();
    } catch (Exception e) {
        errorMessage = "Error loading next appointment: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Upcoming Appointments</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4361ee;
            --secondary-color: #3a0ca3;
            --accent-color: #7209b7;
            --light-bg: #f8f9fa;
            --card-bg: rgba(255, 255, 255, 0.98);
            --glass-effect: rgba(255, 255, 255, 0.85);
            --shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            --success: #28a745;
            --danger: #dc3545;
            --warning: #ffc107;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--light-bg);
            color: #333;
            padding: 20px;
        }

        .glass-card {
            background: var(--glass-effect);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            box-shadow: var(--shadow);
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 2rem;
            margin-bottom: 2rem;
        }

        .header {
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            color: white;
            border-radius: 16px;
            padding: 1.5rem 2rem;
            margin-bottom: 2rem;
        }

        .badge-status {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-weight: 500;
        }

        .status-scheduled {
            background: #e6f7ee;
            color: var(--success);
        }

        .status-completed {
            background: #e6f2ff;
            color: #1a73e8;
        }

        .status-cancelled {
            background: #ffebee;
            color: var(--danger);
        }

        .btn-primary {
            background: var(--primary-color);
            border: none;
            padding: 0.6rem 1.5rem;
            border-radius: 8px;
        }

        .btn-primary:hover {
            background: var(--secondary-color);
        }

        .btn-danger {
            background: var(--danger);
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .table-responsive {
            border-radius: 12px;
            overflow: hidden;
        }

        .table {
            background-color: white;
        }

        .table thead th {
            background-color: var(--primary-color);
            color: white;
            border: none;
        }

        .table tbody tr:hover {
            background-color: rgba(67, 97, 238, 0.1);
        }

        .action-btn {
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.875rem;
            margin-right: 5px;
        }

        .back-btn {
            margin-bottom: 1.5rem;
        }

        .countdown-card {
            background: linear-gradient(135deg, #4cc9f0, #4361ee);
            color: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
        }

        .countdown-timer {
            font-size: 2rem;
            font-weight: 700;
            margin: 1rem 0;
            font-family: 'Courier New', monospace;
        }

        .countdown-label {
            font-size: 0.9rem;
            opacity: 0.9;
            margin-bottom: 0.5rem;
        }

        .appointment-details {
            background: rgba(255, 255, 255, 0.15);
            border-radius: 8px;
            padding: 1rem;
            margin-top: 1rem;
        }

        @media (max-width: 768px) {
            .glass-card {
                padding: 1.5rem;
            }
            
            .header {
                padding: 1rem;
            }
            
            .countdown-timer {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <a href="patientDashboard.jsp" class="btn btn-primary back-btn">
            <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
        </a>
        
        <!-- Countdown Card for Next Appointment -->
        <% if (nextAppointmentTime != null) { %>
        <div class="countdown-card">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <div class="countdown-label">YOUR NEXT APPOINTMENT IN:</div>
                    <div class="countdown-timer" id="countdownTimer">
                        <i class="fas fa-spinner fa-spin"></i> Calculating...
                    </div>
                </div>
                <i class="fas fa-clock fa-3x opacity-25"></i>
            </div>
            
            <div class="appointment-details">
                <div class="row">
                    <div class="col-md-6">
                        <div><i class="fas fa-user-md me-2"></i> <strong><%= nextAppointmentDoctor %></strong></div>
                        <div class="mt-2"><i class="fas fa-calendar-day me-2"></i> <%= nextAppointmentTime.split(" ")[0] %></div>
                    </div>
                    <div class="col-md-6">
                        <div><i class="fas fa-clock me-2"></i> <%= nextAppointmentTime.split(" ")[1] %></div>
                        <div class="mt-2"><i class="fas fa-sticky-note me-2"></i> <%= nextAppointmentReason %></div>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
        <div class="alert alert-info">
            <i class="fas fa-info-circle me-2"></i> You don't have any upcoming appointments scheduled.
        </div>
        <% } %>

        <div class="glass-card">
            <div class="header">
                <h2><i class="fas fa-calendar-alt me-2"></i> My Upcoming Appointments</h2>
            </div>

            <% if (successMessage != null) { %>
                <div class="alert alert-success alert-dismissible fade show">
                    <%= successMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-danger alert-dismissible fade show">
                    <%= errorMessage %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Doctor</th>
                            <th>Date</th>
                            <th>Time</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try (Connection conn = DBUtil.getConnection();
                             PreparedStatement stmt = conn.prepareStatement(
                                 "SELECT a.*, d.specialization FROM appointments a " +
                                 "JOIN doctors d ON a.doctor = d.doctor " +
                                 "WHERE a.username = ? AND a.appointment_date >= CURDATE() " +
                                 "ORDER BY a.appointment_date, a.appointment_time")) {
                            stmt.setString(1, username);
                            ResultSet rs = stmt.executeQuery();

                            boolean hasAppointments = false;

                            while (rs.next()) {
                                hasAppointments = true;
                        %>
                        <tr>
                            <td>#<%= rs.getInt("id") %></td>
                            <td>
                                <strong><%= rs.getString("doctor") %></strong>
                                <div class="text-muted small"><%= rs.getString("specialization") %></div>
                            </td>
                            <td><%= rs.getDate("appointment_date") %></td>
                            <td><%= rs.getTime("appointment_time") %></td>
                            <td><%= rs.getString("reason") %></td>
                            <td>
                                <span class="badge-status status-scheduled">
                                    Scheduled
                                </span>
                            </td>
                            <td>
                                <a href="upcomingAppointments.jsp?deleteId=<%= rs.getInt("id") %>" 
                                   class="btn btn-sm btn-danger action-btn"
                                   onclick="return confirm('Are you sure you want to cancel this appointment?');">
                                   <i class="fas fa-times"></i> Cancel
                                </a>
                                <button class="btn btn-sm btn-primary action-btn" 
                                        onclick="viewDetails(<%= rs.getInt("id") %>)">
                                    <i class="fas fa-eye"></i> View
                                </button>
                            </td>
                        </tr>
                        <%
                            }

                            if (!hasAppointments) {
                        %>
                        <tr>
                            <td colspan="7" class="text-center py-4">
                                <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                                <h5>No upcoming appointments</h5>
                                <p class="text-muted">You don't have any scheduled appointments</p>
                            </td>
                        </tr>
                        <%
                            }
                        } catch (Exception e) {
                        %>
                        <tr>
                            <td colspan="7" class="text-center text-danger py-4">
                                <i class="fas fa-exclamation-triangle fa-2x mb-3"></i>
                                <h5>Error loading appointments</h5>
                                <p><%= e.getMessage() %></p>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function viewDetails(appointmentId) {
            alert("Viewing details for appointment #" + appointmentId);
        }
        
        // Countdown timer for next appointment
        <% if (nextAppointmentTime != null) { %>
        function updateCountdown() {
            const appointmentTime = new Date("<%= nextAppointmentTime %>").getTime();
            const now = new Date().getTime();
            const distance = appointmentTime - now;
            
            if (distance < 0) {
                document.getElementById("countdownTimer").innerHTML = "APPOINTMENT TIME!";
                return;
            }
            
            const days = Math.floor(distance / (1000 * 60 * 60 * 24));
            const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
            const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((distance % (1000 * 60)) / 1000);
            
            let countdownText = "";
            if (days > 0) countdownText += days + "d ";
            if (hours > 0 || days > 0) countdownText += Math.floor(hours) + "h ";
            countdownText += minutes + "m " + seconds + "s";
            
            document.getElementById("countdownTimer").innerHTML = countdownText;
        }
        
        updateCountdown();
        setInterval(updateCountdown, 1000);
        <% } %>
    </script>
</body>
</html>