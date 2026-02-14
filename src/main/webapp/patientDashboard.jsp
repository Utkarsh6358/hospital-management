<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.Date" %>
<%@ page session="true" %>
<%@ page import="java.sql.*, java.util.*, com.hms.util.DBUtil" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%
    String username = (String) session.getAttribute("username");
    List<Map<String, Object>> appointments = new ArrayList<>();

    // Handle appointment cancellation
    String cancelId = request.getParameter("cancelId");
    if (cancelId != null && username != null) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "DELETE FROM appointments WHERE id = ? AND username = ?")) {
            stmt.setInt(1, Integer.parseInt(cancelId));
            stmt.setString(2, username);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                request.setAttribute("successMessage", "Appointment cancelled successfully!");
            } else {
                request.setAttribute("errorMessage", "Failed to cancel appointment or appointment not found.");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error cancelling appointment: " + e.getMessage());
        }
        // Redirect to avoid form resubmission
        response.sendRedirect("PatientDashboardServlet");
        return;
    }

    if (username != null) {
        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT * FROM appointments WHERE username = ? AND appointment_date >= CURDATE() ORDER BY appointment_date, appointment_time"
            )
        ) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> appt = new HashMap<>();
                appt.put("id", rs.getInt("id"));
                appt.put("doctor", rs.getString("doctor"));
                appt.put("appointment_date", rs.getDate("appointment_date"));
                appt.put("appointment_time", rs.getTime("appointment_time"));
                appt.put("reason", rs.getString("reason"));
                appt.put("status", "SCHEDULED");
                appointments.add(appt);
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    request.setAttribute("appointments", appointments);
%>
<%
    // Ensure username is stored at login
    int appointmentCount = 0;

    if (username != null) {
        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) AS total FROM appointments WHERE username = ?");
        ) {
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                appointmentCount = rs.getInt("total");
            }
            rs.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<html>
<head>
    <title>Patient Dashboard</title>
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
        }

        body {
            font-family: 'Poppins', sans-serif;
            background: var(--light-bg);
            color: #333;
        }

        .glass-card {
            background: var(--glass-effect);
            backdrop-filter: blur(10px);
            border-radius: 16px;
            box-shadow: var(--shadow);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
        }

        .sidebar {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            min-height: 100vh;
            padding: 2rem 1.5rem;
            position: sticky;
            top: 0;
        }

        .profile-img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border: 3px solid white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        .nav-link {
            color: rgba(255, 255, 255, 0.8);
            border-radius: 8px;
            margin: 0.25rem 0;
            padding: 0.75rem 1rem;
            transition: all 0.3s;
        }

        .nav-link:hover, .nav-link.active {
            background: rgba(255, 255, 255, 0.15);
            color: white;
        }

        .nav-link i {
            width: 24px;
            text-align: center;
            margin-right: 10px;
        }

        .main-content {
            padding: 2.5rem;
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
            color: #28a745;
        }

        .status-completed {
            background: #e6f2ff;
            color: #1a73e8;
        }

        .status-cancelled {
            background: #ffebee;
            color: #dc3545;
        }

        .appointment-card {
            border-left: 4px solid var(--primary-color);
            transition: all 0.3s;
        }

        .appointment-card:hover {
            transform: translateX(5px);
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

        .floating-btn {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: var(--accent-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 6px 20px rgba(114, 9, 183, 0.3);
            z-index: 100;
            transition: all 0.3s;
        }

        .floating-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(114, 9, 183, 0.4);
        }

        /* Modern form styles */
        .form-control {
            border-radius: 8px;
            padding: 0.75rem 1rem;
            border: 1px solid #e0e0e0;
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
        }

        /* Modal styles */
        .modal-content {
            border-radius: 16px;
            border: none;
        }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            .sidebar {
                min-height: auto;
                position: relative;
            }
            
            .main-content {
                padding: 1.5rem;
            }
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar Navigation -->
        <div class="col-lg-3 col-xl-2 sidebar">
            <div class="d-flex flex-column align-items-center text-center mb-4">
                <img src="https://ui-avatars.com/api/?name=<%= username %>&background=random" 
                     class="profile-img rounded-circle mb-3">
                <h5 class="mb-1">${patient.name}</h5> <h5 class="mb-1"><%= username %> </h5>
                <small class="text-white-50">${patient.username}</small>
            </div>
            
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link active" href="patientDashboard.jsp">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </a>
                </li>
                <!-- Added Profile Button -->
                <li class="nav-item">
                    <a class="nav-link" href="patientProfile.jsp">
                        <i class="fas fa-user"></i> Profile
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="upcomingAppointments.jsp">
                        <i class="fas fa-calendar-check"></i> Appointments
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="displayLabResults.jsp">
                        <i class="fas fa-flask"></i> Lab Results
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="feedback.jsp">
                        <i class="fas fa-comment-alt"></i> Feedback
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="patientSetting.jsp">
                       <i class="fas fa-cog"></i> Settings
                    </a>
                </li>
            </ul>
        </div>

        <!-- Main Content Area -->
        <div class="col-lg-9 col-xl-10 main-content">
            <!-- Dashboard Header -->
            <div class="header glass-card">
                <div class="d-flex justify-content-between align-items-center flex-wrap">
                    <div>
                        <h2 class="mb-1">Welcome back, <%= username %>!          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  SANJEEVANI HOSPITAL</h2>
                        <p class="mb-0">Last login: <%= new Date() %></p>
                    </div>
                    <div>
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="successMessage" scope="session"/>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session"/>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Quick Stats Row -->
            <div class="row mb-4">
                <div class="col-md-4 mb-3">
                    <div class="glass-card p-4 h-100">
                        <div class="d-flex align-items-center">
                            <div class="bg-primary bg-opacity-10 p-3 rounded me-3">
                                <i class="fas fa-calendar-check text-primary"></i>
                            </div>
                            <div>
                                <h5 class="mb-0"><%= appointmentCount %></h5>
                                <small class="text-muted">Upcoming Appointments</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="glass-card p-4 h-100">
                        <div class="d-flex align-items-center">
                            <div class="bg-success bg-opacity-10 p-3 rounded me-3">
                                <i class="fas fa-check-circle text-success"></i>
                            </div>
                            <div>
                                <h5 class="mb-0">${completedTests}</h5>
                                <small class="text-muted">Completed Tests</small>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="glass-card p-4 h-100">
                        <div class="d-flex align-items-center">
                            <div class="bg-info bg-opacity-10 p-3 rounded me-3">
                                <i class="fas fa-prescription-bottle-alt text-info"></i>
                            </div>
                            <div>
                                <h5 class="mb-0">${activePrescriptions}</h5>
                                <small class="text-muted">Active Prescriptions</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Upcoming Appointments Section -->
           <div class="glass-card p-4 mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="mb-0"><i class="fas fa-calendar-alt me-2"></i>Upcoming Appointments</h4>
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#bookAppointmentModal">
                        <i class="fas fa-plus me-1"></i> Book New
                    </button>
                </div>
                
                <c:choose>
                    <c:when test="${empty appointments}">
                        <div class="text-center py-4">
                            <i class="fas fa-calendar-times fa-3x text-muted mb-3"></i>
                            <h5>No upcoming appointments</h5>
                            <p class="text-muted">Book your first appointment to get started</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Doctor</th>
                                        <th>Date & Time</th>
                                        <th>Reason</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${appointments}" var="appt">
                                        <tr>
                                            <td>
                                                <strong>${appt.doctor}</strong>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${appt.appointment_date}" pattern="MMM dd, yyyy"/><br>
                                                <fmt:formatDate value="${appt.appointment_time}" pattern="hh:mm a"/>
                                            </td>
                                            <td>${appt.reason}</td>
                                            <td>
                                                <span class="badge-status status-scheduled">
                                                    SCHEDULED
                                                </span>
                                            </td>
                                            <td>
                                                <button class="btn btn-sm btn-outline-primary" 
                                                        onclick="viewAppointmentDetails('${appt.id}')">
                                                    <i class="fas fa-eye"></i> View
                                                </button>
                                                <a href="PatientDashboardServlet?cancelId=${appt.id}" 
                                                   class="btn btn-sm btn-outline-danger ms-1" 
                                                   onclick="return confirm('Are you sure you want to cancel this appointment?')">
                                                    <i class="fas fa-times"></i> Cancel
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Recent Activities Section -->
            <div class="glass-card p-4">
                <h4 class="mb-3"><i class="fas fa-history me-2"></i>Recent Activities</h4>
                <div class="timeline">
                    <c:forEach items="${recentActivities}" var="activity">
                        <div class="timeline-item mb-3">
                            <div class="d-flex">
                                <div class="timeline-badge bg-${activity.type} me-3">
                                    <i class="fas fa-${activity.icon}"></i>
                                </div>
                                <div class="timeline-content">
                                    <h6 class="mb-1">${activity.title}</h6>
                                    <p class="text-muted small mb-0">${activity.description}</p>
                                    <small class="text-muted">
                                        <i class="far fa-clock me-1"></i>
                                        <fmt:formatDate value="${activity.timestamp}" pattern="MMM dd, hh:mm a"/>
                                    </small>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Book Appointment Modal -->
<div class="modal fade" id="bookAppointmentModal" tabindex="-1" aria-labelledby="bookAppointmentModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title" id="bookAppointmentModalLabel">
                    <i class="fas fa-calendar-plus me-2"></i> Book New Appointment
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="BookAppointmentServlet" method="post">
                <div class="modal-body">
                    <input type="hidden" id="username" name="username" value="${sessionScope.username}" readonly required>    
                    <div class="mb-3">
                        <label for="doctor" class="form-label fw-bold">
                            <i class="fas fa-user-md me-2"></i>Select Doctor
                        </label>
                        <div class="form-group">
                            <label for="doctor">Select Doctor:</label>
                            <select id="doctor" name="doctor" class="form-control" required>
                                <option value="Dr. Arjun Mehta">Dr. Arjun Mehta - Pediatrics (+91-9876543210)</option>
                                <option value="Dr. Priya Sharma">Dr. Priya Sharma - Dermatology (+91-9123456780)</option>
                                <option value="Dr. Rakesh Nair">Dr. Rakesh Nair - Orthopedics (+91-9988776655)</option>
                                <option value="Dr. Sneha Reddy">Dr. Sneha Reddy - Ophthalmology (+91-9090909090)</option>
                                <option value="Dr. Anil Kapoor">Dr. Anil Kapoor - General Medicine (+91-9012345678)</option>
                                <option value="Dr. Kavita Joshi">Dr. Kavita Joshi - ENT Specialist (+91-9023456789)</option>
                                <option value="Dr. Sameer Khan">Dr. Sameer Khan (Cardiology)</option>
                                <option value="Dr. Neha Verma">Dr. Neha Verma (Neurology)</option>
                            </select>
                        </div>
                        <small class="text-muted">Select from our specialist doctors</small>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label for="date" class="form-label fw-bold">
                                <i class="far fa-calendar-alt me-2"></i>Appointment Date
                            </label>
                            <input type="date" class="form-control" id="date" name="date" required 
                                   min="<fmt:formatDate value='<%= new java.util.Date() %>' pattern='yyyy-MM-dd'/>">
                        </div>
                        <div class="col-md-6">
                            <label for="time" class="form-label fw-bold">
                                <i class="far fa-clock me-2"></i>Appointment Time
                            </label>
                            <input type="time" class="form-control" id="time" name="time" 
                                   min="09:00" max="17:00" step="" required>
                            <small class="text-muted">Clinic hours: 9AM - 5PM</small>
                        </div>
                    </div>
                    
                    <div class="mb-3 mt-3">
                        <label for="reason" class="form-label fw-bold">
                            <i class="fas fa-comment-medical me-2"></i>Reason for Appointment
                        </label>
                        <textarea class="form-control" id="reason" name="reason" rows="3" 
                                  placeholder="Please describe your symptoms or reason for visit..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i> Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-calendar-check me-1"></i> Book Appointment
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Floating Action Button -->
<a href="#" class="floating-btn" data-bs-toggle="modal" data-bs-target="#bookAppointmentModal">
    <i class="fas fa-plus"></i>
</a>

<!-- Logout Button -->
<a href="LogoutServlet" class="btn btn-danger position-fixed" style="bottom: 2rem; left: 2rem;">
    <i class="fas fa-sign-out-alt"></i> Logout
</a>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Set minimum date to today for appointment booking
    document.addEventListener('DOMContentLoaded', function() {
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('date').min = today;
        
        // Initialize Bootstrap tooltips
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });
    });
    
    function viewAppointmentDetails(appointmentId) {
        // Implement AJAX call to fetch and display appointment details
        console.log("Viewing appointment: " + appointmentId);
        // You would typically open a modal with detailed view here
    }
    
    // Dynamic header shadow on scroll
    window.addEventListener('scroll', function() {
        const header = document.querySelector('.header');
        if (window.scrollY > 10) {
            header.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.1)';
        } else {
            header.style.boxShadow = 'none';
        }
    });
</script>
</body>
</html>