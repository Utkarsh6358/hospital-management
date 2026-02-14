<%@ page import="java.sql.*, com.hms.util.DBUtil" %>
<%@ page session="true" %>
<%
    String doctorName = (String) session.getAttribute("doctor");
    if (doctorName == null) {
        response.sendRedirect("doctorLogin.jsp");
        return;
    }

    String message = "";
    String messageType = "danger"; // danger for error, success for success

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try (
            Connection conn = DBUtil.getConnection();
            PreparedStatement getDoctor = conn.prepareStatement("SELECT password FROM doctors WHERE doctor = ?");
        ) {
            getDoctor.setString(1, doctorName);
            ResultSet rs = getDoctor.executeQuery();

            if (rs.next()) {
                String currentPassword = rs.getString("password");

                if (!oldPassword.equals(currentPassword)) {
                    message = "Old password is incorrect!";
                } else if (!newPassword.equals(confirmPassword)) {
                    message = "New passwords do not match!";
                } else {
                    // Update doctor record
                    PreparedStatement updateStmt = conn.prepareStatement(
                        "UPDATE doctors SET email = ?, contact = ?, password = ? WHERE doctor = ?"
                    );
                    updateStmt.setString(1, email);
                    updateStmt.setString(2, contact);
                    updateStmt.setString(3, newPassword);
                    updateStmt.setString(4, doctorName);

                    int updated = updateStmt.executeUpdate();
                    if (updated > 0) {
                        message = "Settings updated successfully!";
                        messageType = "success";
                    } else {
                        message = "Update failed!";
                    }
                    updateStmt.close();
                }
            }
            rs.close();
        } catch (Exception e) {
            message = "Error: " + e.getMessage();
        }
    }

    // Pre-fill current email and contact
    String currentEmail = "", currentContact = "";
    try (
        Connection conn = DBUtil.getConnection();
        PreparedStatement stmt = conn.prepareStatement("SELECT email, contact FROM doctors WHERE doctor = ?");
    ) {
        stmt.setString(1, doctorName);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            currentEmail = rs.getString("email");
            currentContact = rs.getString("contact");
        }
        rs.close();
    } catch (Exception e) {
        message = "Error loading doctor info: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Doctor Settings</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4e73df;
            --secondary-color: #f8f9fc;
            --accent-color: #2e59d9;
        }
        
        body {
            background-color: #f8f9fc;
            font-family: 'Nunito', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .settings-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .card-header {
            background-color: var(--primary-color);
            color: white;
            border-radius: 15px 15px 0 0 !important;
            padding: 1.25rem 1.5rem;
        }
        
        .form-control:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.25rem rgba(78, 115, 223, 0.25);
        }
        
        .btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        }
        
        .btn-primary:hover {
            background-color: var(--accent-color);
            border-color: var(--accent-color);
        }
        
        .password-toggle {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
        }
        
        .password-container {
            position: relative;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="d-flex align-items-center mb-4">
                    <a href="DoctorDashboard" class="btn btn-outline-secondary me-3">
                        <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                    </a>
                    <h2 class="h4 text-gray-800 mb-0">Doctor Settings</h2>
                </div>
                
                <div class="card settings-card mb-4">
                    <div class="card-header">
                        <h3 class="h6 mb-0 text-white">
                            <i class="fas fa-user-cog me-2"></i>Account Settings
                        </h3>
                    </div>
                    <div class="card-body p-4">
                        <% if (!message.isEmpty()) { %>
                            <div class="alert alert-<%= messageType %> alert-dismissible fade show" role="alert">
                                <%= message %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <% } %>
                        
                        <form method="post" class="needs-validation" novalidate>
                            <div class="mb-4">
                                <h5 class="mb-3 text-primary">
                                    <i class="fas fa-user me-2"></i>Profile Information
                                </h5>
                                
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email Address</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="<%= currentEmail %>" required>
                                    <div class="invalid-feedback">
                                        Please provide a valid email address.
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="contact" class="form-label">Contact Number</label>
                                    <input type="text" class="form-control" id="contact" name="contact" 
                                           value="<%= currentContact %>" required>
                                    <div class="invalid-feedback">
                                        Please provide your contact number.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="mb-4">
                                <h5 class="mb-3 text-primary">
                                    <i class="fas fa-lock me-2"></i>Password Change
                                </h5>
                                
                                <div class="mb-3 password-container">
                                    <label for="oldPassword" class="form-label">Current Password</label>
                                    <input type="password" class="form-control" id="oldPassword" 
                                           name="oldPassword" required>
                                    <i class="fas fa-eye password-toggle" onclick="togglePassword('oldPassword')"></i>
                                    <div class="invalid-feedback">
                                        Please enter your current password.
                                    </div>
                                </div>
                                
                                <div class="mb-3 password-container">
                                    <label for="newPassword" class="form-label">New Password</label>
                                    <input type="password" class="form-control" id="newPassword" 
                                           name="newPassword" required>
                                    <i class="fas fa-eye password-toggle" onclick="togglePassword('newPassword')"></i>
                                    <div class="invalid-feedback">
                                        Please enter a new password.
                                    </div>
                                </div>
                                
                                <div class="mb-4 password-container">
                                    <label for="confirmPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" class="form-control" id="confirmPassword" 
                                           name="confirmPassword" required>
                                    <i class="fas fa-eye password-toggle" onclick="togglePassword('confirmPassword')"></i>
                                    <div class="invalid-feedback">
                                        Please confirm your new password.
                                    </div>
                                </div>
                            </div>
                            
                            <div class="d-grid">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-save me-2"></i>Save Changes
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
                
                <div class="text-center text-muted mt-3">
                    <small>Logged in as: <strong><%= doctorName %></strong></small>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Password toggle functionality
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const icon = field.nextElementSibling;
            
            if (field.type === "password") {
                field.type = "text";
                icon.classList.replace("fa-eye", "fa-eye-slash");
            } else {
                field.type = "password";
                icon.classList.replace("fa-eye-slash", "fa-eye");
            }
        }
        
        // Form validation
        (function() {
            'use strict';
            
            // Fetch all the forms we want to apply custom Bootstrap validation styles to
            var forms = document.querySelectorAll('.needs-validation');
            
            // Loop over them and prevent submission
            Array.prototype.slice.call(forms)
                .forEach(function(form) {
                    form.addEventListener('submit', function(event) {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        
                        form.classList.add('was-validated');
                    }, false);
                });
        })();
    </script>
</body>
</html>