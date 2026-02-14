<%@ page import="java.sql.*, java.time.LocalDate, com.hms.util.DBUtil" %>
<%@ page session="true" %>
<%
    String doctorName = (String) session.getAttribute("doctor");
    if (doctorName == null) {
        response.sendRedirect("doctorLogin.jsp"); // redirect if not logged in
        return;
    }

    String deleteIdParam = request.getParameter("deleteId");

    // Delete appointment if deleteId is present
    if (deleteIdParam != null) {
        try {
            int deleteId = Integer.parseInt(deleteIdParam);
            Connection delConn = DBUtil.getConnection();
            PreparedStatement delStmt = delConn.prepareStatement(
                "DELETE FROM appointments WHERE id = ? AND doctor = ?"
            );
            delStmt.setInt(1, deleteId);
            delStmt.setString(2, doctorName);
            delStmt.executeUpdate();
            delStmt.close();
            delConn.close();
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Failed to delete: " + e.getMessage() + "</div>");
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Doctor - Upcoming Appointments</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #f8f9fc;
            --accent-color: #2e59d9;
            --text-color: #5a5c69;
        }
        
        body {
            background-color: #f8f9fc;
            color: var(--text-color);
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            transition: transform 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }
        
        .card-header {
            background-color: var(--primary-color);
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 1.5rem;
        }
        
        .table-responsive {
            border-radius: 0 0 15px 15px;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table th {
            background-color: var(--secondary-color);
            border-top: none;
            font-weight: 600;
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
        }
        
        .btn-outline-danger {
            color: #e74a3b;
            border-color: #e74a3b;
        }
        
        .btn-outline-danger:hover {
            background-color: #e74a3b;
            color: white;
        }
        
        .next-appointment-banner {
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--accent-color) 100%);
            color: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .countdown {
            font-size: 1.5rem;
            font-weight: bold;
        }
        
        .no-appointments {
            text-align: center;
            padding: 2rem;
            color: #858796;
        }
        
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid py-4">
        <div class="row mb-4">
            <div class="col-12">
                <a href="DoctorDashboard" class="btn btn-outline-secondary mb-3">
                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                </a>
                <h2 class="h4 text-gray-800">Upcoming Appointments</h2>
                <p class="mb-0">View and manage your upcoming appointments</p>
            </div>
        </div>

        <!-- Next Appointment Banner -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="next-appointment-banner">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h3 class="h5 mb-1">Next Appointment</h3>
                            <%
                                try (
                                    Connection conn = DBUtil.getConnection();
                                    PreparedStatement stmt = conn.prepareStatement(
                                        "SELECT * FROM appointments WHERE doctor = ? AND appointment_date >= CURDATE() " +
                                        "ORDER BY appointment_date, appointment_time LIMIT 1"
                                    )
                                ) {
                                    stmt.setString(1, doctorName);
                                    ResultSet rs = stmt.executeQuery();
                                    
                                    if (rs.next()) {
                                        String nextAppointmentDate = rs.getDate("appointment_date").toString();
                                        String nextAppointmentTime = rs.getTime("appointment_time").toString();
                                        String patientName = rs.getString("username");
                                        String reason = rs.getString("reason");
                            %>
                            <p class="mb-2">
                                <strong><%= patientName %></strong> - <%= reason %>
                                <br>
                                <i class="far fa-calendar-alt me-1"></i> <%= nextAppointmentDate %> 
                                <i class="far fa-clock me-1 ms-2"></i> <%= nextAppointmentTime %>
                            </p>
                            <div class="countdown" id="countdownTimer">
                                <i class="fas fa-spinner fa-spin"></i> Calculating time remaining...
                            </div>
                            <script>
                                // Set the countdown timer
                                function updateCountdown() {
                                    const appointmentDate = new Date("<%= nextAppointmentDate %> <%= nextAppointmentTime %>").getTime();
                                    const now = new Date().getTime();
                                    const distance = appointmentDate - now;
                                    
                                    if (distance < 0) {
                                        document.getElementById("countdownTimer").innerHTML = "Appointment time has arrived";
                                        return;
                                    }
                                    
                                    const days = Math.floor(distance / (1000 * 60 * 60 * 24));
                                    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
                                    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
                                    const seconds = Math.floor((distance % (1000 * 60)) / 1000);
                                    
                                    let countdownText = "";
                                    if (days > 0) countdownText += days + "d ";
                                    if (hours > 0 || days > 0) countdownText += Math.floor(hours) + "h ";
                                    countdownText += minutes + "m " + seconds + "s remaining";
                                    
                                    document.getElementById("countdownTimer").innerHTML = countdownText;
                                }
                                
                                updateCountdown();
                                setInterval(updateCountdown, 1000);
                            </script>
                            <%
                                    } else {
                            %>
                            <p class="mb-0">No upcoming appointments scheduled</p>
                            <%
                                    }
                                    rs.close();
                                } catch (Exception e) {
                            %>
                            <p class="mb-0">Error loading next appointment: <%= e.getMessage() %></p>
                            <%
                                }
                            %>
                        </div>
                        <div class="col-md-4 text-md-end">
                            <i class="fas fa-calendar-check fa-4x opacity-25"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Appointments Table -->
        <div class="row">
            <div class="col-12">
                <div class="card shadow mb-4">
                    <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                        <h6 class="m-0 font-weight-bold text-white">All Upcoming Appointments</h6>
                        <div>
                            <span class="badge bg-white text-primary">
                                <i class="fas fa-calendar-day me-1"></i>
                                <%= LocalDate.now().toString() %>
                            </span>
                        </div>
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Patient</th>
                                    <th>Date</th>
                                    <th>Time</th>
                                    <th>Reason</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    try (
                                        Connection conn = DBUtil.getConnection();
                                        PreparedStatement stmt = conn.prepareStatement(
                                            "SELECT * FROM appointments WHERE doctor = ? AND appointment_date >= CURDATE() ORDER BY appointment_date, appointment_time"
                                        )
                                    ) {
                                        stmt.setString(1, doctorName);
                                        ResultSet rs = stmt.executeQuery();
                                        
                                        boolean hasAppointments = false;
                                        
                                        while (rs.next()) {
                                            hasAppointments = true;
                                            String appointmentDate = rs.getDate("appointment_date").toString();
                                            String appointmentTime = rs.getTime("appointment_time").toString();
                                %>
                                <tr>
                                    <td><%= rs.getInt("id") %></td>
                                    <td>
                                        <i class="fas fa-user me-2 text-primary"></i>
                                        <%= rs.getString("username") %>
                                    </td>
                                    <td><%= appointmentDate %></td>
                                    <td><%= appointmentTime %></td>
                                    <td><%= rs.getString("reason") %></td>
                                    <td class="action-buttons">
                                        <a href="doctorUpcomingAppointments.jsp?deleteId=<%= rs.getInt("id") %>" 
                                           class="btn btn-outline-danger btn-sm"
                                           onclick="return confirm('Are you sure you want to cancel this appointment?');">
                                           <i class="fas fa-times me-1"></i>Cancel
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                        
                                        if (!hasAppointments) {
                                %>
                                <tr>
                                    <td colspan="6" class="no-appointments">
                                        <i class="far fa-calendar-times fa-3x mb-3 text-gray-400"></i>
                                        <h5 class="text-gray-500">No Upcoming Appointments</h5>
                                        <p class="text-muted">You don't have any scheduled appointments at this time.</p>
                                    </td>
                                </tr>
                                <%
                                        }
                                        
                                        rs.close();
                                    } catch (Exception e) {
                                %>
                                <tr>
                                    <td colspan="6" class="text-center text-danger py-4">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        Error loading appointments: <%= e.getMessage() %>
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
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>