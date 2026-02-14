<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sanjeevani Hospital</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary: #4a90e2;
            --secondary: #6a11cb;
            --white: #ffffff;
            --dark: #2c3e50;
            --light: #f8f9fa;
        }

        body {
            background: 
                linear-gradient(rgba(245, 247, 250, 0.9), rgba(195, 207, 226, 0.9)),
                url('https://images.unsplash.com/photo-1579684385127-1ef15d508118?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            overflow-x: hidden;
        }

        .hospital-logo {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--dark);
            margin-bottom: 1rem;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.1);
        }

        .hospital-logo i {
            color: var(--primary);
            margin-right: 0.5rem;
        }

        .hero-section {
            padding: 5rem 0;
            text-align: center;
            background-color: rgba(255, 255, 255, 0.85);
            border-radius: 20px;
            margin: 2rem auto;
            max-width: 1200px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255,255,255,0.3);
        }

        .card-option {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            background: rgba(255,255,255,0.95);
            height: 100%;
            border: 1px solid rgba(255,255,255,0.3);
        }

        .card-option:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }

        .card-option .card-body {
            padding: 2.5rem;    
        }

        .card-icon {
            font-size: 3rem;
            margin-bottom: 1.5rem;
            color: var(--primary);
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .btn-option {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            border: none;
            border-radius: 50px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            color: var(--white);
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(74, 144, 226, 0.3);
        }

        .btn-option:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(74, 144, 226, 0.4);
            color: var(--white);
        }

        .welcome-text {
            font-size: 1.2rem;
            color: var(--dark);
            opacity: 0.9;
            margin-bottom: 3rem;
        }

        .footer {
            margin-top: 3rem;
            padding: 2rem 0;
            background: rgba(255, 255, 255, 0.9);
            text-align: center;
            border-radius: 20px;
            box-shadow: 0 -5px 20px rgba(0,0,0,0.05);
        }

        .pulse {
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        /* Background pattern overlay */
        .bg-pattern {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: radial-gradient(rgba(74, 144, 226, 0.1) 1px, transparent 1px);
            background-size: 20px 20px;
            z-index: -1;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <div class="bg-pattern"></div>
    <div class="container">
        <div class="hero-section">
            <div class="hospital-logo">
                <i class="fas fa-heartbeat pulse"></i>Sanjeevani Hospital
            </div>
            <p class="welcome-text">
                Where Care Meets Compassion - Your Health, Our Priority
            </p>

            <div class="row justify-content-center">
                <div class="col-md-5 mb-4">
                    <div class="card-option">
                        <div class="card-body text-center">
                            <div class="card-icon">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <h3 class="card-title mb-3">Doctor Login</h3>
                            <p class="card-text mb-4">
                                Access patient records, manage appointments, and provide medical care.
                            </p>
                            <a href="doctorLogin.jsp?role=doctor" class="btn btn-option">
                                <i class="fas fa-sign-in-alt me-2"></i>Doctor Portal
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-md-5 mb-4">
                    <div class="card-option">
                        <div class="card-body text-center">
                            <div class="card-icon">
                                <i class="fas fa-user-injured"></i>
                            </div>
                            <h3 class="card-title mb-3">Patient Login</h3>
                            <p class="card-text mb-4">
                                Book appointments, view medical history, and access health records.
                            </p>
                            <a href="patientLogin.jsp?role=patient" class="btn btn-option">
                                <i class="fas fa-sign-in-alt me-2"></i>Patient Portal
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="footer">
            <p class="mb-0">© 2025 Sanjeevani Hospital. All Rights Reserved.</p>
            <div class="mt-2">
                <a href="#" class="text-decoration-none me-3"><i class="fas fa-phone me-1"></i> Emergency:Call Shreya!!</a>
                <a href="#" class="text-decoration-none me-3"><i class="fas fa-envelope me-1"></i> help@shreya.com</a>
                <a href="#" class="text-decoration-none"><i class="fas fa-map-marker-alt me-1"></i>Atria Girls Hostel</a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add animation on scroll
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.card-option');
            
            cards.forEach((card, index) => {
                // Add delay to each card animation
                card.style.transitionDelay = `${index * 0.1}s`;
            });
        });
    </script>
</body>
</html>