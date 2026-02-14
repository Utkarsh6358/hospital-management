<%@ page import="java.sql.*, com.hms.util.DBUtil" %>
<%@ page session="true" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Submit Feedback</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            padding: 20px;
        }
        .feedback-container {
            max-width: 650px;
            margin: 0 auto;
            padding: 2.5rem;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: fadeIn 0.6s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .feedback-header {
            color: #2c3e50;
            margin-bottom: 1.8rem;
            text-align: center;
            position: relative;
            padding-bottom: 15px;
            font-weight: 600;
        }
        .feedback-header:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 25%;
            width: 50%;
            height: 3px;
            background: linear-gradient(90deg, #3498db, #9b59b6);
            border-radius: 3px;
        }
        .form-label {
            font-weight: 500;
            color: #34495e;
            margin-bottom: 0.5rem;
        }
        .btn-submit {
            background: linear-gradient(135deg, #3498db 0%, #9b59b6 100%);
            border: none;
            padding: 12px 30px;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.4s;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
        }
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(52, 152, 219, 0.4);
        }
        .btn-back {
            background: linear-gradient(135deg, #95a5a6 0%, #7f8c8d 100%);
            border: none;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.4s;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(149, 165, 166, 0.2);
        }
        .btn-back:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(149, 165, 166, 0.3);
        }
        .feedback-textarea {
            border-radius: 12px;
            border: 1px solid #dfe6e9;
            transition: all 0.3s;
            min-height: 180px;
            padding: 15px;
            font-size: 15px;
            background-color: #f8fafc;
        }
        .feedback-textarea:focus {
            border-color: #3498db;
            box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.15);
            background-color: white;
        }
        .message {
            margin: 1.5rem 0;
            padding: 1rem;
            border-radius: 10px;
            text-align: center;
            font-weight: 500;
            animation: slideIn 0.5s ease-out;
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .success {
            background-color: rgba(212, 237, 218, 0.8);
            color: #155724;
            border-left: 4px solid #28a745;
        }
        .error {
            background-color: rgba(248, 215, 218, 0.8);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        .button-group {
            display: flex;
            justify-content: space-between;
            margin-top: 2rem;
            gap: 15px;
        }
        .form-group {
            margin-bottom: 1.8rem;
        }
        .character-count {
            text-align: right;
            font-size: 0.85rem;
            color: #7f8c8d;
            margin-top: 0.3rem;
        }
        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: -1;
        }
        .shape {
            position: absolute;
            opacity: 0.15;
            border-radius: 50%;
        }
        .shape-1 {
            width: 300px;
            height: 300px;
            background: #3498db;
            top: -100px;
            left: -100px;
        }
        .shape-2 {
            width: 200px;
            height: 200px;
            background: #9b59b6;
            bottom: -50px;
            right: -50px;
        }
    </style>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Floating background shapes -->
    <div class="floating-shapes">
        <div class="shape shape-1"></div>
        <div class="shape shape-2"></div>
    </div>

    <div class="container">
        <div class="feedback-container">
            <h2 class="feedback-header">Share Your Valuable Feedback</h2>
            
            <%
                String message = "";
                String messageClass = "";
                if ("POST".equalsIgnoreCase(request.getMethod())) {
                    String username = (String) session.getAttribute("username");
                    String feedbackText = request.getParameter("feedback");

                    if (username != null && feedbackText != null && !feedbackText.trim().isEmpty()) {
                        try (Connection conn = DBUtil.getConnection();
                             PreparedStatement ps = conn.prepareStatement("INSERT INTO feedback (username, feedback_text) VALUES (?, ?)")) {
                            ps.setString(1, username);
                            ps.setString(2, feedbackText);
                            ps.executeUpdate();
                            message = "Thank you for your feedback! We truly appreciate your time and input.";
                            messageClass = "success";
                        } catch (Exception e) {
                            message = "We encountered an issue while submitting your feedback. Please try again later.";
                            messageClass = "error";
                        }
                    } else {
                        message = "Please share your thoughts with us before submitting.";
                        messageClass = "error";
                    }
                }
            %>

            <% if (!message.isEmpty()) { %>
                <div class="message <%= messageClass %>">
                    <%= message %>
                </div>
            <% } %>

            <form method="post" class="mt-4">
                <div class="form-group">
                    <label for="feedback" class="form-label">Your honest feedback helps us improve</label>
                    <textarea class="form-control feedback-textarea" id="feedback" name="feedback" 
                              placeholder="We'd love to hear about your experience... What worked well? What could be better?"
                              required></textarea>
                    <div class="character-count"><span id="charCount">0</span>/500 characters</div>
                </div>
                
                <div class="button-group">
                    <a href="patientDashboard.jsp" class="btn btn-back">
                        <i class="bi bi-arrow-left"></i> Return to Dashboard
                    </a>
                    <button type="submit" class="btn btn-submit">
                        <i class="bi bi-send-fill"></i> Submit Feedback
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Character count for feedback textarea
        const textarea = document.getElementById('feedback');
        const charCount = document.getElementById('charCount');
        
        textarea.addEventListener('input', function() {
            const currentLength = this.value.length;
            charCount.textContent = currentLength;
            
            if (currentLength > 500) {
                charCount.style.color = '#e74c3c';
            } else {
                charCount.style.color = '#7f8c8d';
            }
        });
    </script>
</body>
</html>