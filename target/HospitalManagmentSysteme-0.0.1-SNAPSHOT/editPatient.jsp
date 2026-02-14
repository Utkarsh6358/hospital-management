<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Edit Patient</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2a9d8f;
            --secondary-color: #264653;
            --gradient-bg: linear-gradient(135deg, #e0a2a1 0%, #12dadb 100%);
        }

        body {
            background: var(--gradient-bg);
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
        }

        .form-container {
            max-width: 200%;
            margin: 2rem auto;
            padding: 2.5rem;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: slideIn 0.6s ease-out;
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        .form-header {
            color: var(--secondary-color);
            padding-bottom: 1.5rem;
            margin-bottom: 2rem;
            border-bottom: 2px solid var(--primary-color);
        }

        .input-group {
            position: relative;
            margin-bottom: 1.8rem;
        }

        .form-control {
            border-radius: 12px;
            padding: 1rem 1.5rem;
            border: 2px solid #e0e0e0;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(42,157,143,0.1);
        }

        .input-icon {
            position: absolute;
            right: 1.5rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary-color);
        }

        .btn-save {
            background: linear-gradient(45deg, var(--primary-color), #21867a);
            color: white;
            padding: 1rem 2.5rem;
            border-radius: 12px;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(42,157,143,0.3);
        }

        .btn-cancel {
            background: linear-gradient(34deg, #6c75ff, #5a62fa);
            color: white;
        }

        .logout-btn {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            padding: 1rem 2rem;
            border-radius: 12px;
            background: linear-gradient(45deg, #ff4757, #ff6b6b);
            color: white;
            box-shadow: 0 5px 15px rgba(255,71,87,0.3);
        }

        @media (max-width: 768px) {
            .form-container {
                margin: 1rem;
                padding: 1.5rem;
            }
            
            .logout-btn {
                bottom: 1rem;
                right: 1rem;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-container">
        <h2 class="form-header text-center mb-4">
            <i class="bi bi-person-gear me-2"></i>
            Edit Patient Profile
        </h2>
        
        <form action="UpdatePatientServlet" method="post" id="patientForm">
            <input type="hidden" name="username" value="${patient.username}">
            
            <div class="row g-4">
                <!-- Name Field -->
                <div class="col-md-6">
                    <div class="input-group">
                        <label class="form-label fw-bold mb-2">
                            <i class="bi bi-person-circle me-2"></i>
                            Full Name
                        </label>
                        <input type="text" class="form-control" name="name" 
                               value="${patient.name}" required>
                        <i class="bi bi-pencil input-icon"></i>
                    </div>
                </div>

                <!-- Date of Birth Field -->
                <div class="col-md-6">
                    <div class="input-group">
                        <label class="form-label fw-bold mb-2">
                            <i class="bi bi-calendar2-date me-2"></i>
                            Date of Birth
                        </label>
                        <input type="date" class="form-control" name="dob" 
                               value="${patient.dob}" required id="dobInput">
                    </div>
                </div>

                <!-- Address Field -->
                <div class="col-12">
                    <div class="input-group">
                        <label class="form-label fw-bold mb-2">
                            <i class="bi bi-house-door me-2"></i>
                            Address
                        </label>
                        <input type="text" class="form-control" name="address" 
                               value="${patient.address}" required>
                    </div>
                </div>

                <!-- Phone Field -->
                <div class="col-md-6">
                    <div class="input-group">
                        <label class="form-label fw-bold mb-2">
                            <i class="bi bi-telephone me-2"></i>
                            Phone Number
                        </label>
                        <input type="tel" class="form-control" name="phone" 
                               value="${patient.phone}" required id="phoneInput">
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="col-12 mt-5">
                    <div class="d-flex justify-content-end gap-3">
                        <a href="DoctorDashboardServlet" class="btn btn-cancel">
                            <i class="bi bi-x-lg me-2"></i>Cancel
                        </a>
                        <button type="submit" class="btn btn-save">
                            <i class="bi bi-save me-2"></i>Save Changes
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <!-- Logout Button -->
    <a href="LogoutServlet" class="btn logout-btn">
        <i class="bi bi-box-arrow-right me-2"></i>Logout
    </a>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Phone Number Formatting
    document.getElementById('phoneInput').addEventListener('input', function(e) {
        this.value = this.value.replace(/\D/g, '')
            .replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
    });

    // Date Validation
    const dobInput = document.getElementById('dobInput');
    dobInput.max = new Date().toISOString().split('T')[0];
    
    dobInput.addEventListener('change', () => {
        const selectedDate = new Date(dobInput.value);
        const today = new Date();
        if (selectedDate > today) {
            dobInput.setCustomValidity("Invalid future date");
            dobInput.reportValidity();
        }
    });

    // Form Validation
    document.getElementById('patientForm').addEventListener('submit', function(e) {
        let isValid = true;
        
        this.querySelectorAll('[required]').forEach(input => {
            if (!input.value.trim()) {
                input.classList.add('is-invalid');
                isValid = false;
            }
        });

        if (!isValid) {
            e.preventDefault();
            this.querySelector('.is-invalid').scrollIntoView({
                behavior: 'smooth',
                block: 'center'
            });
        }
    });

    // Input Validation Feedback
    document.querySelectorAll('input').forEach(input => {
        input.addEventListener('input', () => {
            if (input.checkValidity()) {
                input.classList.remove('is-invalid');
            }
        });
    });
</script>
</body>
</html>