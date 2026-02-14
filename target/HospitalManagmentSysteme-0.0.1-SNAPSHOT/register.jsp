<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Patient Registration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4a90e2;
            --success: #28a745;
            --error: #dc3545;
            --card-bg: #ffffff;
            --border-radius: 12px;
        }

        body {
            background-color: #f5f9ff;
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
            padding: 2rem;
        }

        .registration-card {
            background: var(--card-bg);
            border-radius: var(--border-radius);
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
        }

        .form-header {
            background: var(--primary);
            color: white;
            border-radius: var(--border-radius) var(--border-radius) 0 0;
            padding: 2rem;
            text-align: center;
        }

        .form-header i {
            margin-right: 0.5rem;
        }

        .input-group-custom {
            position: relative;
            margin: 1.5rem;
        }

        .form-control {
            border: 1px solid #ced4da;
            border-radius: 8px;
            padding: 1rem;
            font-size: 0.9rem;
            transition: all 0.2s ease;
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 2px rgba(74, 144, 226, 0.2);
        }

        .password-strength {
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin-top: 0.5rem;
        }

        .strength-bar {
            height: 100%;
            transition: width 0.3s ease;
        }

        .btn-register {
            background: var(--primary);
            color: white;
            border: 0;
            border-radius: 25px;
            padding: 1rem 2rem;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .btn-register:hover {
            background: #2c7be5;
            box-shadow: 0 2px 8px rgba(44, 123, 229, 0.3);
        }

        .login-link a {
            color: var(--primary);
            text-decoration: underline;
        }

        .divider {
            border: 0;
            border-top: 1px solid #e9ecef;
            margin: 2rem 0;
        }

        .validation-feedback {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--success);
            display: none;
        }

        .input-group-custom.valid .validation-feedback {
            display: block;
        }

        .input-group-custom.invalid .form-control {
            border-color: var(--error);
        }

        .input-group-custom.invalid .validation-feedback {
            display: none;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="registration-card">
        <div class="form-header">
            <h2 class="mb-2"><i class="fas fa-heartbeat"></i> Patient Registration</h2>
            <p class="mb-0">Join our healthcare community</p>
        </div>
        <div class="form-body p-4">
            <form action="RegisterServlet" method="post" id="registrationForm" novalidate>
                <div class="row g-3">
                    <!-- User name -->
                    <div class="col-md-6">
                        <div class="input-group-custom">
                            <input type="text" class="form-control" name="username" 
                                   placeholder="Username" required
                                   pattern="[A-Za-z0-9]{4,20}">
                            <i class="fas fa-user input-icon"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="invalid-feedback">4-20 characters (letters/numbers only)</div>
                        </div>
                    </div>
                    <!-- Password -->
                    <div class="col-md-6">
                        <div class="input-group-custom">
                            <input type="text" class="form-control" name="password" 
                                   id="password" placeholder="Password" required
                                   pattern="^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{6,}$">
                            <i class="fas fa-lock input-icon password-toggle"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="password-strength">
                                <div class="strength-bar" id="strengthBar"></div>
                            </div>
                            <div class="invalid-feedback">Minimum 6 characters with 1 letter & 1 number</div>
                        </div>
                    </div>
                    <!-- Full Name -->
                    <div class="col-12">
                        <div class="input-group-custom">
                            <input type="text" class="form-control" name="name" 
                                   placeholder="Full Name" required>
                            <i class="fas fa-id-card input-icon"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="invalid-feedback">Please enter your full name</div>
                        </div>
                    </div>
                    <!-- Date of Birth -->
                    <div class="col-md-6">
                        <div class="input-group-custom">
                            <input type="date" class="form-control" name="dob" 
                                   id="dob" required max="">
                            <i class="fas fa-calendar-day input-icon"></i>
                            <div class="invalid-feedback">Please select your date of birth</div>
                        </div>
                    </div>
                    <!-- Phone Number -->
                    <div class="col-md-6">
                        <div class="input-group-custom">
                            <input type="text" class="form-control" name="phone" 
                                   placeholder="Phone Number" required
                                   pattern="[0-9]{10,15}">
                            <i class="fas fa-phone input-icon"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="invalid-feedback">10-15 digit phone number required</div>
                        </div>
                    </div>
                    <!-- Address -->
                    <div class="col-12">
                        <div class="input-group-custom">
                            <input type="text" class="form-control" name="address" 
                                   placeholder="Address" required>
                            <i class="fas fa-map-marker-alt input-icon"></i>
                            <span class="validation-feedback"><i class="fas fa-check"></i></span>
                            <div class="invalid-feedback">Please enter your address</div>
                        </div>
                    </div>
                    <!-- Terms Checkbox -->
                    <div class="col-12">
                        <div class="form-check ms-3">
                            <input class="form-check-input" type="checkbox" id="terms" required>
                            <label class="form-check-label" for="terms">
                                I agree to the <a href="#" class="text-primary">Terms</a> and 
                                <a href="#" class="text-primary">Privacy Policy</a>
                            </label>
                        </div>	
                    </div>
                    <!-- Submit Button -->
                    <div class="col-12">
                        <button type="submit" class="btn-register w-100">
                            <i class="fas fa-user-plus me-2"></i>Create Account
                        </button>
                    </div>
                    <c:if test="${not empty error}">
    <div class="error">${error}</div>
</c:if>
                    
                </div>
            </form>
            <div class="login-link text-center mt-3">
                Already have an account? <a href="index.jsp">Sign In Here</a>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Password Strength Calculator
    const calculatePasswordStrength = (password) => {
        let strength = 0;
        if (password.length