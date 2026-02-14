<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% 
String error = request.getParameter("error");
if (error != null) {
    String message = "";
    if (error.equals("1")) message = "Invalid credentials";
    else if (error.equals("session_expired")) message = "Session expired, please login again";
    else if (error.equals("patient_not_found")) message = "Patient record not found";
    else if (error.equals("database_error")) message = "System error, please try again";
%>
    <div class="error-message"><%= message %></div>
<% } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Patient Login - Sanjeevani Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #3a7bd5;
            --secondary: #00d2ff;
            --accent: #ff7e5f;
            --light: #ffffff;
            --dark: #2c3e50;
            --success: #2ecc71;
            --danger: #e74c3c;
            --patient-theme: #6a5acd;
            --glass-bg: rgba(255, 255, 255, 0.85);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background: 
                linear-gradient(rgba(106, 90, 205, 0.1), rgba(106, 90, 205, 0.1)),
                url('https://img.freepik.com/free-vector/clean-medical-background_53876-97927.jpg?semt=ais_hybrid&w=740') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
        }
        
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(106, 90, 205, 0.05);
            z-index: -1;
        }
        
        .login-container {
            background: var(--glass-bg);
            width: 100%;
            max-width: 450px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
            text-align: center;
            animation: fadeIn 0.8s ease-out;
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .medical-icon {
            margin-bottom: 25px;
        }
        
        .medical-icon i {
            font-size: 4rem;
            background: linear-gradient(135deg, var(--patient-theme), #9370db);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            filter: drop-shadow(0 5px 15px rgba(106, 90, 205, 0.3));
        }
        
        h1 {
            color: var(--dark);
            margin-bottom: 30px;
            font-size: 2rem;
            background: linear-gradient(135deg, var(--patient-theme), #9370db);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .form-group {
            margin-bottom: 25px;
            text-align: left;
            position: relative;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            color: var(--dark);
            font-weight: 500;
        }
        
        label i {
            margin-right: 10px;
            color: var(--patient-theme);
        }
        
        input {
            width: 100%;
            padding: 15px 15px 15px 45px;
            border: 2px solid rgba(106, 90, 205, 0.2);
            border-radius: 10px;
            font-size: 1rem;
            transition: all 0.3s;
            background: rgba(255, 255, 255, 0.8);
        }
        
        input:focus {
            border-color: var(--patient-theme);
            outline: none;
            box-shadow: 0 0 0 3px rgba(106, 90, 205, 0.2);
            background: white;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 40px;
            color: var(--patient-theme);
        }
        
        .btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--patient-theme), #9370db);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 10px;
            box-shadow: 0 5px 15px rgba(106, 90, 205, 0.3);
        }
        
        .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(106, 90, 205, 0.4);
            background: linear-gradient(135deg, #5d4cb1, #8368d2);
        }
        
        .btn i {
            margin-left: 8px;
        }
        
        .options-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        
        .register-link, .forgot-link {
            text-align: center;
            color: var(--dark);
        }
        
        .register-link a, .forgot-link a {
            color: var(--patient-theme);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
        }
        
        .register-link a:hover, .forgot-link a:hover {
            text-decoration: underline;
            color: #5d4cb1;
        }
        
        .register-link a i, .forgot-link a i {
            margin-right: 6px;
        }
        
        .error {
            color: var(--danger);
            text-align: center;
            margin-top: 20px;
            font-weight: 500;
            padding: 10px;
            border-radius: 5px;
            background-color: rgba(231, 76, 60, 0.1);
            animation: shake 0.5s;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            20%, 60% { transform: translateX(-5px); }
            40%, 80% { transform: translateX(5px); }
        }
        
        .home-btn-container {
            position: absolute;
            top: 30px;
            left: 30px;
            z-index: 100;
        }
        
        .home-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 15px;
            background: linear-gradient(135deg, var(--patient-theme), #9370db);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 4px 10px rgba(106, 90, 205, 0.3);
        }
        
        .home-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 15px rgba(106, 90, 205, 0.4);
            background: linear-gradient(135deg, #5d4cb1, #8368d2);
        }
        
        .home-btn i {
            font-size: 16px;
        }
        
        .hospital-brand {
            position: absolute;
            top: 30px;
            right: 30px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .hospital-brand i {
            font-size: 1.8rem;
            color: var(--patient-theme);
        }
        
        .hospital-brand h2 {
            background: linear-gradient(135deg, var(--patient-theme), #9370db);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 1.5rem;
        }
    </style>
</head>
<body>
    <!-- Home Button -->
    <div class="home-btn-container">
        <a href="index.jsp" class="home-btn">
            <i class="fas fa-home"></i> Home
        </a>
    </div>
    
    <!-- Hospital Brand -->
    <div class="hospital-brand">
        <i class="fas fa-heartbeat"></i>
        <h2>Sanjeevani</h2>
    </div>
    
    <div class="login-container">
        <div class="medical-icon">
            <i class="fas fa-user-injured"></i>
        </div>
        <h1>Patient Login</h1>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="error">
                <i class="fas fa-exclamation-circle"></i> Invalid login credentials
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
    <p style="color:red;">Invalid username or password.</p>
<% } %>
        
        
        <form action="LoginServelets" method="post" id="loginForm">
            <div class="form-group">
                <label><i class="fas fa-envelope"></i> Username</label>
                <input type="text" name="username" placeholder="Enter your username" required>
            </div>
            
            <div class="form-group">
                <label><i class="fas fa-lock"></i> Password</label>
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>
            
            <button type="submit" class="btn">
                Sign In <i class="fas fa-sign-in-alt"></i>
            </button>
            
        </form>
        
        <div class="options-container">
            <div class="register-link">
            New to Sanjeevani? <a href="register.jsp">Create an account</a>
        </div>
    </div>
            
        </div>
    </div>

    <script>
        // Add loading animation to form submission
        document.getElementById('loginForm').addEventListener('submit', function() {
            const btn = this.querySelector('button[type="submit"]');
            btn.innerHTML = 'Signing In <i class="fas fa-spinner fa-spin"></i>';
            btn.disabled = true;
        });
    </script>
</body>
</html>