<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Lab Results</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #2a9d8f;
            --secondary-color: #264653;
            --gradient-bg: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
        }

        body {
            background: var(--gradient-bg);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
        }

        .header-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 25px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.3);
        }

        .lab-table-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            padding: 1.5rem;
            margin: 2rem 0;
        }

        .table-custom {
            border-collapse: separate;
            border-spacing: 0 0.8rem;
            width: 100%;
        }

        .table-custom thead {
            background: linear-gradient(135deg, var(--primary-color), #21867a);
            color: white;
        }

        .table-custom th {
            padding: 1.2rem;
            font-weight: 600;
            border: none;
        }

        .table-custom td {
            padding: 1.2rem;
            background: #fff;
            vertical-align: middle;
            border: 1px solid #f0f0f0;
        }

        .table-custom tr {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border-radius: 12px;
        }

        .table-custom tr:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.08);
        }

        .status-badge {
            padding: 0.6rem 1.2rem;
            border-radius: 25px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .badge-normal { background: #d1fae5; color: #065f46; }
        .badge-abnormal { background: #fef3c7; color: #92400e; }
        .badge-critical { background: #fee2e2; color: #991b1b; }

        .action-btn {
            padding: 0.6rem 1rem;
            border-radius: 8px;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-delete {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .btn-delete:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(239,68,68,0.3);
        }

        .logout-btn {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            padding: 1rem 2rem;
            border-radius: 12px;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 5px 20px rgba(239,68,68,0.2);
        }

        @media (max-width: 768px) {
            .main-container {
                padding: 1rem;
            }
            
            .table-custom {
                display: block;
                overflow-x: auto;
            }
        }
    </style>
</head>
<body>
<div class="main-container">
    <!-- Header Section -->
    <div class="header-card">
        <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div>
                <h2 class="mb-3"><i class="bi bi-clipboard2-pulse"></i> Laboratory Results</h2>
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-person-circle"></i>
                    <h5 class="mb-0">Patient: ${patient.name}</h5>
                </div>
            </div>
            <a href="AddLabResultServlet?id=${patient.username}" class="btn btn-primary">
                <i class="bi bi-plus-lg"></i> New Test
            </a>
        </div>
    </div>

    <!-- Success Message -->
    <c:if test="${not empty param.success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${param.success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Lab Results Table -->
    <div class="lab-table-container">
        <table class="table-custom">
            <thead>
                <tr>
                    <th>Test Name</th>
                    <th>Date</th>
                    <th>Result</th>
                    <th>Comments</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${patient.labResults}" var="lab">
                    <tr>
                        <td>${lab.testName}</td>
                        <td>${lab.date}</td>
                        <td>
                            <span class="status-badge 
                                <c:choose>
                                    <c:when test="${lab.result == 'Normal'}">badge-normal</c:when>
                                    <c:when test="${lab.result == 'Abnormal'}">badge-abnormal</c:when>
                                    <c:otherwise>badge-critical</c:otherwise>
                                </c:choose>">
                                <i class="bi 
                                    <c:choose>
                                        <c:when test="${lab.result == 'Normal'}">bi-check-circle</c:when>
                                        <c:when test="${lab.result == 'Abnormal'}">bi-exclamation-triangle</c:when>
                                        <c:otherwise>bi-x-circle</c:otherwise>
                                    </c:choose>">
                                </i>
                                ${lab.result}
                            </span>
                        </td>
                        <td>${lab.doctorComments}</td>
                        <td>
                            <a href="DeleteLabResultServlet?patientId=${patient.username}&labId=${lab.testId}" 
                               class="action-btn btn-delete"
                               onclick="return confirm('Delete this lab result?')">
                                <i class="bi bi-trash"></i> Delete
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- Navigation & Logout -->
    <div class="d-flex justify-content-between align-items-center mt-4">
        <a href="patientDashboard.jsp" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> Back to Dashboard
        </a>
    </div>
</div>

<!-- Logout Button -->
<a href="LogoutServlet" class="btn logout-btn">
    <i class="bi bi-box-arrow-right"></i> Logout
</a>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-hide success message
    const alert = document.querySelector('.alert');
    if(alert) {
        setTimeout(() => {
            alert.classList.add('fade');
            setTimeout(() => alert.remove(), 300);
        }, 5000);
    }

    // Table row hover effect
    document.querySelectorAll('.table-custom tr').forEach(row => {
        row.addEventListener('mouseenter', () => {
            row.style.transform = 'translateY(-3px)';
        });
        row.addEventListener('mouseleave', () => {
            row.style.transform = 'translateY(0)';
        });
    });

    // Smooth scroll for alerts
    window.addEventListener('load', () => {
        if(window.location.hash === '#alert') {
            document.querySelector('.alert').scrollIntoView({ behavior: 'smooth' });
        }
    });
</script>
</body>
</html>