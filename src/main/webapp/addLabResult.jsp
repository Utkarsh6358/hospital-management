<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add Lab Result</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2a9d8f;
            --secondary-color: #264653;
            --gradient-bg: linear-gradient(135deg, #e3121d 0%, #111efb 100%);
            --glass-bg: rgba(255, 255, 255, 0.95);
        }

        body {
            background: var(--gradient-bg);
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
        }

        .form-container {
            max-width: 400%;
            margin: 2rem auto;
            padding: 2.5rem;
            background: var(--glass-bg);
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.3);
            animation: slideIn 0.6s cubic-bezier(0.4, 0, 0.2, 1);
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
            margin-bottom: 1.8rem;
            position: relative;
        }

        .form-control {
            border-radius: 12px;
            padding: 1rem 1.5rem;
            border: 2px solid #e0e0e0;
            transition: all 0.3s ease;
            background: rgba(255,255,255,0.9);
        }

        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 4px rgba(42,157,143,0.1);
        }

        .btn-save {
            background: linear-gradient(135deg, var(--primary-color), #21117a);
            color: white;
            padding: 1rem 2.5rem;
            border-radius: 12px;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-save:hover {
            transform: translateY(-12px);
            box-shadow: 0 8px 20px rgba(42,157,143,0.3);
        }

        .btn-cancel {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
        }

        .logout-btn {
            position: fixed;
            bottom: 2rem;
            right: 2rem;
            padding: 1rem 2rem;
            border-radius: 12px;
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
            box-shadow: 0 5px 15px rgba(239,68,68,0.3);
        }

        .input-icon {
            position: absolute;
            right: 1.5rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--primary-color);
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
            <i class="bi bi-clipboard2-pulse me-2"></i>
            New Lab Result
        </h2>
        
        <form action="AddLabResultServlet" method="post" id="labForm">
            <input type="hidden" name="patientUsername" value="${patientUsername}">
            
            <!-- Test Name -->
            <div class="input-group">
                <label classform-label fw-bold mb-2">
                    <i class="bi bi-file-medical me-2"></i>
                    Test Name
                </label>
                <input type="text" class="form-control" name="testName" 
                       placeholder="Enter test name" required>
                <i class="bi bi-pencil input-icon"></i>
            </div>

            <!-- Date & Result -->
            <div class="row g-4 mb-4">
                <div class="col-md-6">
                    <div class="input-group">
                        <label class="form-label fw-bold mb-2">
                            <i class="bi bi-calendar2-check me-2"></i>
                            Date
                        </label>
                        <input type="date" class="form-control" name="date" 
                               required id="dateInput">
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="input-group">
                        <label class="form-label fw-bold mb-2">
                            <i class="bi bi-clipboard2-data me-2"></i>
                            Result
                        </label>
                        <select class="form-select" name="result" required>
                            <option value="Normal">Normal</option>
                            <option value="Abnormal">Abnormal</option>
                            <option value="Critical">Critical</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Comments -->
            <div class="input-group">
                <label class="form-label fw-bold mb-2">
                    <i class="bi bi-chat-left-text me-2"></i>
                    Comments
                </label>
                <textarea class="form-control" name="comments" rows="4" 
                          placeholder="Enter clinical notes"></textarea>
            </div>

            <!-- Action Buttons -->
            <div class="d-flex justify-content-end gap-3 mt-5">
                <a href="displayLabResults.jsp"${patientUsername}
                   class="btn btn-cancel">
                    <i class="bi bi-x-lg me-2"></i>Cancel
                </a>
                <button type="submit" class="btn btn-save">
                    <i class="bi bi-save me-2"></i>Save Result
                </button>
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
    // Date Validation
    const dateInput = document.getElementById('dateInput');
    dateInput.value = new Date().toISOString().split('T')[0];
    
    dateInput.addEventListener('change', () => {
        const selectedDate = new Date(dateInput.value);
        const today = new Date();
        if(selectedDate > today) {
            dateInput.setCustomValidity("Future dates not allowed");
            dateInput.reportValidity();
        } else {
            dateInput.setCustomValidity("");
        }
    });

    // Form Validation
    document.getElementById('labForm').addEventListener('submit', function(e) {
        let isValid = true;
        
        this.querySelectorAll('[required]').forEach(input => {
            if(!input.value.trim()) {
                input.classList.add('is-invalid');
                isValid = false;
            }
        });

        if(!isValid) {
            e.preventDefault();
            this.querySelector('.is-invalid').scrollIntoView({
                behavior: 'smooth',
                block: 'center'
            });
        }
    });

    // Input Validation Feedback
    document.querySelectorAll('input, select, textarea').forEach(element => {
        element.addEventListener('input', () => {
            if(element.checkValidity()) {
                element.classList.remove('is-invalid');
            }
        });
    });
</script>
</body>
</html>