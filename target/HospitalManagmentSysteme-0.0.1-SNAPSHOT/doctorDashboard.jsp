<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page session="true" %>
<%@ page import="java.sql.*, com.hms.util.DBUtil" %>
<%
    int totalPatients = 0;
    int totalAppointments = 0;
    int totalDoctors = 0;

    try (Connection conn = DBUtil.getConnection()) {
        // Count patients
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM patients");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalPatients = rs.getInt("total");
        }

        // Count appointments
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM appointments");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalAppointments = rs.getInt("total");
        }

        // Count doctors
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) AS total FROM doctors");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) totalDoctors = rs.getInt("total");
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>





<!DOCTYPE html>
<html>
<head>
    <title>Doctor Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    <style>
        :root {
            --primary-color: #4a6bff;
            --secondary-color: #6c757d;
            --success-color: #28a745;
            --danger-color: #dc3545;
            --warning-color: #ffc107;
            --info-color: #17a2b8;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --sidebar-width: 280px;
            --header-height: 80px;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f5f7fb;
            color: #333;
            overflow-x: hidden;
        }

        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            background: white;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.05);
            z-index: 1000;
            transition: all 0.3s;
        }

        .sidebar-brand {
            height: var(--header-height);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.5rem;
            color: var(--primary-color);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .sidebar-menu {
            padding: 1.5rem 0;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 0.8rem 1.5rem;
            color: var(--secondary-color);
            text-decoration: none;
            transition: all 0.3s;
            margin: 0.2rem 0;
        }

        .sidebar-menu a:hover, .sidebar-menu a.active {
            color: var(--primary-color);
            background: rgba(74, 107, 255, 0.1);
            border-left: 3px solid var(--primary-color);
        }

        .sidebar-menu a i {
            margin-right: 0.8rem;
            font-size: 1.1rem;
        }

        .main-content {
            margin-left: var(--sidebar-width);
            width: calc(100% - var(--sidebar-width));
            min-height: 100vh;
            transition: all 0.3s;
        }

        .header {
            height: var(--header-height);
            background: white;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.05);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2rem;
            position: sticky;
            top: 0;
            z-index: 999;
        }

        .user-profile {
            display: flex;
            align-items: center;
        }

        .user-profile img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 1rem;
            object-fit: cover;
        }

        .user-info h6 {
            margin-bottom: 0;
            font-weight: 600;
        }

        .user-info small {
            color: var(--secondary-color);
            font-size: 0.8rem;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.05);
            transition: all 0.3s;
            margin-bottom: 1.5rem;
        }
	
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .card-icon {
            width: 50px;
            height: 50px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1rem;
        }

        .card-icon.patients {
            background: linear-gradient(45deg, #4a6bff, #6a8aff);
        }

        .card-icon.appointments {
            background: linear-gradient(45deg, #28a745, #5cb85c);
        }

        .card-icon.specialization {
            background: linear-gradient(45deg, #ffc107, #ffd54f);
        }

        .card-body h5 {
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .card-body p {
            color: var(--secondary-color);
            margin-bottom: 0;
        }

        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
        }

        .table thead th {
            border-top: none;
            border-bottom: 1px solid #dee2e6;
            font-weight: 600;
            color: var(--secondary-color);
            text-transform: uppercase;
            font-size: 0.8rem;
            letter-spacing: 0.5px;
        }

        .table tbody tr {
            transition: all 0.3s;
        }

        .table tbody tr:hover {
            background: rgba(74, 107, 255, 0.05);
        }

        .badge-status {
            padding: 0.4rem 0.8rem;
            border-radius: 50px;
            font-weight: 500;
            font-size: 0.75rem;
        }

        .badge-primary {
            background: rgba(74, 107, 255, 0.1);
            color: var(--primary-color);
        }

        .badge-success {
            background: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }

        .badge-warning {
            background: rgba(255, 193, 7, 0.1);
            color: var(--warning-color);
        }

        .action-btn {
            padding: 0.4rem 0.8rem;
            border-radius: 6px;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            margin-right: 0.5rem;
        }

        .action-btn i {
            margin-right: 0.3rem;
        }

        .btn-view {
            background: rgba(74, 107, 255, 0.1);
            color: var(--primary-color);
            border: none;
        }

        .btn-view:hover {
            background: rgba(74, 107, 255, 0.2);
            color: var(--primary-color);
        }

        .btn-edit {
            background: rgba(255, 193, 7, 0.1);
            color: var(--warning-color);
            border: none;
        }

        .btn-edit:hover {
            background: rgba(255, 193, 7, 0.2);
            color: var(--warning-color);
        }

        .btn-delete {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
            border: none;
        }

        .btn-delete:hover {
            background: rgba(220, 53, 69, 0.2);
            color: var(--danger-color);
        }

        .btn-lab {
            background: rgba(23, 162, 184, 0.1);
            color: var(--info-color);
            border: none;
        }

        .btn-lab:hover {
            background: rgba(23, 162, 184, 0.2);
            color: var(--info-color);
        }

        .search-box {
            position: relative;
            max-width: 300px;
        }

        .search-box input {
            padding-left: 2.5rem;
            border-radius: 50px;
            border: 1px solid #e0e0e0;
        }

        .search-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-color);
        }

        .patient-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: var(--primary-color);
        }

        .empty-state {
            text-align: center;
            padding: 2rem;
            color: var(--secondary-color);
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            color: #e0e0e0;
        }

        @media (max-width: 992px) {
            .sidebar {
                transform: translateX(-100%);
            }
            .sidebar.active {
                transform: translateX(0);
            }
            .main-content {
                margin-left: 0;
                width: 100%;
            }
            .header {
                padding: 0 1rem;
            }
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <!-- Sidebar -->
<div class="sidebar">
    <div class="sidebar-brand">
        SANJEEVANI HOSPITAL
    </div>
    <div class="sidebar-menu">
        <a href="#" class="active">
            <i class="fas fa-tachometer-alt"></i>
            <span>Dashboard</span>
        </a>
        <a href="doctorUpcomingAppointments.jsp">
            <i class="fas fa-calendar-check"></i>
            <span>Appointments</span>
        </a>
        <a href="viewPatients.jsp">
            <i class="fas fa-user-injured"></i>
            <span>Patients</span>
        </a>
        <a href="viewFeedback.jsp">
            <i class="fas fa-comment-medical"></i>
            <span>View Feedback</span>
        </a>
        <a href="doctorSetting.jsp">
            <i class="fas fa-cog"></i>
            <span>Settings</span>
        </a>
        <a href="LogoutServlet">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </div>
</div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <div class="header">
            <div>
                <button class="btn btn-outline-primary d-lg-none" id="sidebarToggle">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
            <div class="search-box">
                <i class="fas fa-search"></i>
                <input type="text" class="form-control" placeholder="Search patients..." id="searchInput">
            </div>
            <div class="user-profile">
                <img src="https://ui-avatars.com/api/?name=${doctor.name}&background=4a6bff&color=fff" alt="Doctor">
                <div class="user-info">
                    <h6>Welcome ${doctor.name}!</h6>
                    <small>${doctor.specialization}</small>
                </div>
            </div>
        </div>

        <!-- Content -->
        <div class="container-fluid p-4">
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card animate__animated animate__fadeInUp">
                        <div class="card-body">
                            <div class="card-icon patients">
                                <i class="fas fa-user-injured"></i>
                            </div>
                            <h5><%= totalPatients %></h5>
                            <p>Total Patients</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card animate__animated animate__fadeInUp" style="animation-delay: 0.1s">
                        <div class="card-body">
                            <div class="card-icon appointments">
                                <i class="fas fa-calendar-check"></i>
                            </div>
                            <h5><%= totalAppointments %></h5>
                            <p>Upcoming Appointments</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card animate__animated animate__fadeInUp" style="animation-delay: 0.2s">
                        <div class="card-body">
                            <div class="card-icon specialization">
                                <i class="fas fa-stethoscope"></i>
                            </div>
                            <h5><%= totalDoctors %></h5>
                            <p>Specialization</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-12">
                    <div class="table-container animate__animated animate__fadeIn">
                        
                        
                        <c:choose>
                            <c:when test="${empty patients}">
                                
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover" id="patientsTable">
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Patient</th>
                                                <th>Username</th>
                                                <th>Date of Birth</th>
                                                <th>Contact</th>
                                                <th>Address</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${patients}" var="patient" varStatus="loop">
                                                <tr>
                                                    <td>${loop.index + 1}</td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="patient-avatar me-2">
                                                                ${patient.name.charAt(0)}
                                                            </div>
                                                            <div>
                                                                <strong>${patient.name}</strong>
                                                                <div class="text-muted small">${patient.gender}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>${patient.username}</td>
                                                    <td>${patient.dob}</td>
                                                    <td>${patient.phone}</td>
                                                    <td>${patient.address}</td>
                                                    <td>
                                                        <div class="d-flex">
                                                            <a href="DisplayLabResultsServlet?id=${patient.username}" 
                                                               class="action-btn btn-view me-2" 
                                                               data-bs-toggle="tooltip" 
                                                               title="View Medical Records">
                                                                <i class="fas fa-file-medical"></i>
                                                            </a>
                                                            <a href="EditPatientServlet?id=${patient.username}" 
                                                               class="action-btn btn-edit me-2"
                                                               data-bs-toggle="tooltip" 
                                                               title="Edit Patient">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <a href="AddLabResultServlet?id=${patient.username}" 
                                                               class="action-btn btn-lab me-2"
                                                               data-bs-toggle="tooltip" 
                                                               title="Add Lab Result">
                                                                <i class="fas fa-flask"></i>
                                                            </a>
                                                            <a href="DeletePatientServlet?id=${patient.username}" 
                                                               class="action-btn btn-delete"
                                                               onclick="return confirm('Are you sure you want to delete ${patient.name}?')"
                                                               data-bs-toggle="tooltip" 
                                                               title="Delete Patient">
                                                                <i class="fas fa-trash"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Toggle sidebar on mobile
        document.getElementById('sidebarToggle').addEventListener('click', function() {
            document.querySelector('.sidebar').classList.toggle('active');
        });

        // Initialize tooltips
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Search functionality
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const rows = document.querySelectorAll('#patientsTable tbody tr');
            
            rows.forEach(row => {
                const cells = row.querySelectorAll('td');
                let shouldShow = false;
                
                // Check each cell (except the last one with actions)
                for (let i = 0; i < cells.length - 1; i++) {
                    if (cells[i].textContent.toLowerCase().includes(searchTerm)) {
                        shouldShow = true;
                        break;
                    }
                }
                
                row.style.display = shouldShow ? '' : 'none';
            });
        });

        // Add animation to cards on load
        document.addEventListener('DOMContentLoaded', function() {
            // Cards already have animation classes
            // Add any additional initialization here
        });
    </script>
</body>
</html>