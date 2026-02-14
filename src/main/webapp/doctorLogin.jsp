<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Login - Sanjeevani Hospital</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #3a7bd5;
            --primary-dark: #2a5aa5;
            --secondary: #00d2ff;
            --accent: #ff7e5f;
            --light: #ffffff;
            --dark: #2c3e50;
            --dark-light: #4a5a6e;
            --success: #2ecc71;
            --danger: #e74c3c;
            --gray: #f5f7fa;
            --gray-dark: #e0e6ed;
            --transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }
        
        body {
            background: 
                linear-gradient(rgba(58, 123, 213, 0.2), rgba(0, 210, 255, 0.1)),
                url('https://images.unsplash.com/photo-1576091160550-2173dba999ef?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: var(--dark);
            padding: 20px;
            position: relative;
            
        }
        
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(2px);
            z-index: -1;
        }
        
        
        .login-container {
            background-color: white;
            width: 100%;
            max-width: 450px;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
        }
        
        .medical-icon {
            font-size: 3rem;
            color: var(--primary);
            margin-bottom: 15px;
        }
        
        h1 {
            font-size: 1.8rem;
            margin-bottom: 25px;
            color: var(--dark);
            font-weight: 600;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
            position: relative;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark-light);
            font-size: 14px;
        }
        
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 1px solid var(--gray-dark);
            border-radius: 8px;
            font-size: 15px;
            transition: var(--transition);
        }
        
        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(58, 123, 213, 0.2);
        }
        
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 40px;
            color: var(--dark-light);
            cursor: pointer;
        }
        
        .btn {
            width: 100%;
            padding: 12px;
            background: linear-gradient(to right, var(--primary), var(--secondary));
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 15px;
        }
        
        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(58, 123, 213, 0.3);
        }
        
        .options-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            font-size: 14px;
        }
        
        .remember-me {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .remember-me input {
            accent-color: var(--primary);
        }
        
        .forgot-password a {
            color: var(--dark-light);
            text-decoration: none;
            transition: var(--transition);
        }
        
        .forgot-password a:hover {
            color: var(--primary);
            text-decoration: underline;
        }
        
        .register-link {
            margin-top: 20px;
            color: var(--dark-light);
            font-size: 14px;
        }
        
        .register-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
        }
        
        .register-link a:hover {
            text-decoration: underline;
        }
        
        .error-message {
            margin-top: 15px;
            padding: 10px;
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--danger);
            border-radius: 6px;
            font-size: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .home-btn {
            position: absolute;
            top: 20px;
            left: 20px;
            padding: 8px 15px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 14px;
            transition: var(--transition);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .home-btn:hover {
            background: var(--primary-dark);
        }
        
        @media (max-width: 480px) {
            .login-container {
                padding: 30px;
            }
            
            h1 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <a href="index.jsp" class="home-btn">
        <i class="fas fa-home"></i> Home
    </a>
    
    
    <div class="login-container">
        <div class="medical-icon">
            <i class="fas fa-user-md"></i>
        </div>
        <h1>Doctor Login</h1>
        
        <form action="DoctorLoginServlet" method="post" id="loginForm">
            <div class="form-group">
                <label for="email">Email Address</label>
                 <input type="email" name="email" placeholder="Enter your email" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" name="password" name="password" placeholder="Enter your password" required>
                <i class="fas fa-eye password-toggle" id="togglePassword"></i>
            </div>
            
            <div class="options-row">
                <div class="remember-me">
                    <input type="checkbox" id="remember" name="remember">
                    <label for="remember">Remember me</label>
                </div>
                <div class="forgot-password">
                    <a href="#">Forgot password?</a>
                </div>
            </div>
            
            <button type="submit" class="btn">
                Sign In <i class="fas fa-sign-in-alt"></i>
            </button>	
        </form>
           </div>

        <% if (request.getParameter("error") != null) { %>
            <div class="error-message">
                <i class="fas fa-exclamation-circle"></i>
                <span>Invalid email or password. Please try again.</span>
            </div>
        <% } %>
        
        

    <script>
        // Toggle password visibility
        const togglePassword = document.getElementById('togglePassword');
        const password = document.getElementById('password');
        
        togglePassword.addEventListener('click', function() {
            const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
            password.setAttribute('type', type);
            this.classList.toggle('fa-eye');
            this.classList.toggle('fa-eye-slash');
        });
        
        // Form submission loading state
        const loginForm = document.getElementById('loginForm');
        
        loginForm.addEventListener('submit', function() {
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = 'Signing in... <i class="fas fa-spinner fa-spin"></i>';
            submitBtn.disabled = true;
        });
    </script>
</body>
</html>