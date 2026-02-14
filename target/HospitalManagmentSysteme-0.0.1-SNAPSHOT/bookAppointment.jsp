<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book Appointment</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #2c3e50;
            text-align: center;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="date"], input[type="time"], select, textarea {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        button {
            background-color: #3498db;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        button:hover {
            background-color: #2980b9;
        }
        .message {
            padding: 10px;
            margin-bottom: 15px;
            border-radius: 4px;
        }
        .error {
            background-color: #ffdddd;
            color: #d32f2f;
        }
        .success {
            background-color: #ddffdd;
            color: #388e3c;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Book Appointment</h2>
        
        <!-- Display success/error messages -->
        <c:if test="${not empty successMessage}">
            <div class="message success">
                ${successMessage}
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage}">
            <div class="message error">
                ${errorMessage}
            </div>
        </c:if>
        
        <form action="BookAppointmentServlet" method="post">
            <div class="form-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" value="${sessionScope.username}" readonly required>
            </div>
            
            <div class="form-group">
                <label for="doctor">Select Doctor:</label>
                <select id="doctor" name="doctor" required>
                    <option value="">-- Select Doctor --</option>
                    <option value="Dr. Arjun Mehta">Dr. Arjun Mehta - Pediatrics (+91-9876543210)</option>
<option value="Dr. Priya Sharma">Dr. Priya Sharma - Dermatology (+91-9123456780)</option>
<option value="Dr. Rakesh Nair">Dr. Rakesh Nair - Orthopedics (+91-9988776655)</option>
<option value="Dr. Sneha Reddy">Dr. Sneha Reddy - Ophthalmology (+91-9090909090)</option>
<option value="Dr. Anil Kapoor">Dr. Anil Kapoor - General Medicine (+91-9012345678)</option>
<option value="Dr. Kavita Joshi">Dr. Kavita Joshi - ENT Specialist (+91-9023456789)</option>
<option value="Dr. Sameer Khan">Dr. Sameer Khan (Cardiology)</option>
<option value="Dr. Neha Verma">Dr. Neha Verma (Neurology)</option>
<option value="Dr. Arjun Mehta">Dr. Arjun Mehta (Pediatrics)</option>
<option value="Dr. Priya Sharma">Dr. Priya Sharma (Dermatology)</option>

                </select>
            </div>
            
            <div class="form-group">
                <label for="date">Appointment Date:</label>
                <input type="date" id="date" name="date" required>
            </div>
            
            <div class="form-group">
                <label for="time">Appointment Time:</label>
                <input type="time" id="time" name="time" required>
            </div>
            
            <div class="form-group">
                <label for="reason">Reason for Appointment:</label>
                <textarea id="reason" name="reason" rows="4" required></textarea>
            </div>
            
            <button type="submit">Book Appointment</button>
        </form>
    </div>

    <script>
        // Set minimum date to today
        document.getElementById('date').min = new Date().toISOString().split('T')[0];
        
        // Set working hours (9am-5pm)
        document.getElementById('time').min = '09:00';
        document.getElementById('time').max = '17:00';
    </script>
</body>
</html> 