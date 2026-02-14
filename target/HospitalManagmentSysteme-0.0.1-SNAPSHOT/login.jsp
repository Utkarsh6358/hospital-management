<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hospital Management</title>
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
<style>
    /* Modern gradient background with animation [[6]] */
    body {
        background: linear-gradient(45deg, #6a11cb, #2575fc);
        background-size: 400% 400%;
        animation: gradientBG 15s ease infinite;
        min-height: 100vh;
    }
    
    @keyframes gradientBG {
        0% { background-position: 0% 50%; }
        50% { background-position: 100% 50%; }
        100% { background-position: 0% 50%; }
    }

    /* Updated container layout with floating effect [[3]] */
    .login-container {
        max-width: 500px;
        margin: 80px auto;
        padding: 40px;
        background: rgba(255, 255, 255, 0.9);
        border-radius: 20px;
        box-shadow: 0 15px 50px rgba(0,0,0,0.2);
        backdrop-filter: blur(10px);
        transform-style: preserve-3d;
        transition: transform 0.3s ease;
    }

    /* Interactive hover effects [[7]] */
    .login-container:hover {
        transform: translateY(-5px) rotateX(5deg);
        box-shadow: 0 20px 70px rgba(0,0,0,0.3);
    }

    /* Enhanced form styling with modern aesthetics [[3]] */
    .form-control {
        border: none;
        border-radius: 12px;
        padding: 15px;
        background: rgba(240, 240, 240, 0.8);
        transition: all 0.3s ease;
    }

    .form-control:focus {
        background: white;
        box-shadow: 0 0 0 2px #8c54ff;
        transform: scale(1.02);
    }

    /* Animated button with gradient [[6]] */
    .btn-login {
        background: linear-gradient(135deg, #6a11cb 0%, #2575fc 100%);
        color: white;
        padding: 15px;
        border-radius: 25px;
        transition: all 0.3s ease;
        margin-top: 20px;
    }

    .btn-login:hover {
        background: linear-gradient(135deg, #2575fc 0%, #6a11cb 100%);
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(37, 117, 252, 0.4);
    }

    /* Floating labels effect [[7]] */
    .form-group {
        position: relative;
        margin-bottom: 25px;
    }

    .form-group label {
        position: absolute;
        top: 15px;
        left: 15px;
        color: #999;
        transition: all 0.3s ease;
        pointer-events: none;
    }

    .form-control:focus + label,
    .form-control:not(:placeholder-shown) + label {
        top: -10px;
        left: 10px;
        font-size: 12px;
        color: #6a11cb;
        background: white;
        padding: 0 5px;
    }
</style>
</head>
<body>
    <div class="login-container">
        <h2 class="login-title text-center text-primary mb-4">Hospital Portal</h2>
        
        <!-- Added loading state [[9]] -->
        <form action="LoginServelets" method="post" id="loginForm">
            <div class="form-group">
                <input type="text" class="form-control" name="username" 
                       placeholder=" " required autocomplete="off">
                <label>Email</label>
            </div>
            <div class="form-group">
                <input type="password" class="form-control" name="password" 
                       placeholder=" " required autocomplete="off">
                <label>Password</label>
            </div>
            
            <button type="submit" class="btn btn-login btn-block">
                <span class="spinner-border spinner-border-sm d-none" 
                      role="status" aria-hidden="true" id="loading"></span>
                Sign In
            </button>
        </form>

        <div class="text-center mt-3">
            <a href="register.jsp" class="text-decoration-none text-muted">
                <small>New patient? Create account</small>
            </a>
        </div>
        
        <!-- Enhanced alert styling [[3]] -->
        <% if(request.getParameter("registered") != null) { %>
            <div class="alert alert-success mt-3 shadow-sm" role="alert">
                <i class="fas fa-check-circle mr-2"></i> Registration successful!
            </div>
        <% } %>
    </div>

    <!-- Added interactivity [[9]] -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#loginForm').submit(function() {
                $('#loading').removeClass('d-none');
                $('button[type="submit"]').prop('disabled', true);
            });
        });
    </script>
</body>
</html>