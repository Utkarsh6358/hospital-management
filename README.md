# 🏥 Sanjeevani — Hospital Management System

> A full-stack hospital management web application built with Java, JSP, Servlets, Maven, and MySQL to simplify patient care, appointment management, doctor workflows, and medical record handling.




\

---

## 📌 Overview

**Sanjeevani** is a web-based Hospital Management System designed to digitize and streamline common hospital operations.

The application provides dedicated workflows for **patients and doctors**, allowing users to manage profiles, appointments, laboratory results, and feedback through a centralized web interface.

The backend follows a layered Java architecture with separate **DAO, Model, Servlet, and Utility** components, while JSP is used to build the web interface.

---

## ✨ Features

### 👤 Patient Management

* Patient registration and login
* Patient dashboard
* Patient profile management
* Account settings
* View upcoming appointments
* Book doctor appointments
* View laboratory results
* Submit feedback

### 👨‍⚕️ Doctor Management

* Doctor authentication
* Doctor dashboard
* View upcoming appointments
* Manage doctor settings
* Access patient-related information
* Add laboratory results

### 📅 Appointment Management

* Book appointments with available doctors
* Select appointment date and time
* Record the reason for consultation
* View upcoming appointments
* Associate appointments with patients and doctors

### 🧪 Laboratory Management

* Add laboratory test results
* Associate results with patients
* Store test dates and result information
* Add additional medical comments
* Allow patients to view their laboratory results

### 💬 Feedback

* Patients can submit feedback
* Feedback is stored in the database
* Hospital-side interface can retrieve submitted feedback

---

## 🏗️ Architecture

The project follows a layered MVC-inspired architecture:

```text
                    ┌─────────────────────┐
                    │      JSP / UI       │
                    │ Patient & Doctor UI │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      Servlets       │
                    │ Request Processing  │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │        DAO          │
                    │ Database Operations │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │       MySQL         │
                    │    Sanjeevani DB    │
                    └─────────────────────┘
```

### Project Structure

```text
hospital-management/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── hms/
│       │           ├── dao/
│       │           ├── model/
│       │           ├── servelets/
│       │           └── util/
│       │
│       └── webapp/
│           ├── META-INF/
│           ├── WEB-INF/
│           ├── patientDashboard.jsp
│           ├── patientProfile.jsp
│           ├── doctorDashboard.jsp
│           ├── bookAppointment.jsp
│           ├── displayLabResults.jsp
│           ├── addLabResult.jsp
│           └── ...
│
├── sanjeevani_db.sql
├── pom.xml
├── Procfile
├── railway.json
└── README.md
```

---

## 🛠️ Tech Stack

| Layer                 | Technology                        |
| --------------------- | --------------------------------- |
| Language              | Java 17                           |
| Frontend              | JSP, HTML, CSS, JavaScript        |
| Backend               | Java Servlets                     |
| Database              | MySQL                             |
| Database Connectivity | JDBC                              |
| Template Technology   | JSTL                              |
| JSON Processing       | Jackson                           |
| Build Tool            | Maven                             |
| Application Packaging | WAR                               |
| Deployment            | Railway                           |
| Server Runtime        | Servlet container / WebApp Runner |

---

## 🗄️ Database Design

The application uses a MySQL database named:

```text
sanjeevani
```

### Main Tables

```text
patients
    │
    ├─────────────── appointments
    │                    │
    │                    └──────── doctors
    │
    ├─────────────── feedback
    │
    └─────────────── lab_results
```

### Core Entities

**Patients**

Stores patient identity, login credentials, contact information, date of birth, and address.

**Doctors**

Stores doctor credentials, specialization, contact information, and doctor identity.

**Appointments**

Connects patients with doctors and stores appointment date, time, and consultation reason.

**Lab Results**

Stores diagnostic test information associated with individual patients.

**Feedback**

Stores feedback submitted by patients.

The repository includes the complete SQL schema and sample data in `sanjeevani_db.sql`.

---

## 🚀 Getting Started

### Prerequisites

Make sure you have the following installed:

* Java JDK 17+
* Maven
* MySQL 8+
* Git
* A Java Servlet container such as Tomcat

---

### 1. Clone the Repository

```bash
git clone https://github.com/Utkarsh6358/hospital-management.git

cd hospital-management
```

---

### 2. Configure MySQL

Create the database by importing the provided SQL file:

```bash
mysql -u root -p < sanjeevani_db.sql
```

Or import `sanjeevani_db.sql` through MySQL Workbench.

---

### 3. Configure Database Credentials

Update the database configuration used by the application with your local MySQL credentials.

Example:

```text
Database: sanjeevani
Host: localhost
Port: 3306
Username: your_username
Password: your_password
```

> ⚠️ Never commit production database credentials or passwords to GitHub.

---

### 4. Build the Application

```bash
mvn clean package
```

The Maven build generates a WAR file under:

```text
target/
```

---

### 5. Run the Application

Deploy the generated WAR file to a compatible servlet container such as Apache Tomcat.

Alternatively, the project includes deployment configuration for Railway.

---

## ☁️ Deployment

The repository includes Railway deployment configuration.

The deployment pipeline builds the project using:

```bash
mvn clean package -DskipTests
```

and starts the generated WAR through WebApp Runner.

For a production deployment, configure database credentials using environment variables rather than committing them to the repository.

---

## 🔐 Security Notes

This project is intended primarily as an educational and portfolio application.

Before using it in a real healthcare environment, additional security controls should be implemented, including:

* Password hashing
* Secure session management
* Role-based access control
* Input validation
* CSRF protection
* HTTPS enforcement
* Secure environment-variable management
* Database credential protection
* Audit logging
* Proper handling of sensitive medical information

> This project should not be used as-is for production healthcare workloads or real patient data.

---

## 📸 Screenshots

Screenshots of the application are available in the [`ScreenShoots`](./ScreenShoots) directory.

### Patient Dashboard

### Doctor Dashboard

### Appointment Booking

> Replace the image filenames above with the exact filenames available in the `ScreenShoots` directory.

---

## 🔮 Future Improvements

Potential improvements include:

* [ ] Spring Boot migration
* [ ] REST API layer
* [ ] JWT-based authentication
* [ ] Password hashing and stronger authentication
* [ ] Role-based authorization
* [ ] Admin dashboard
* [ ] Online billing and payments
* [ ] Prescription management
* [ ] Email/SMS appointment notifications
* [ ] Doctor availability scheduling
* [ ] Advanced search and filtering
* [ ] Automated testing
* [ ] Docker support
* [ ] CI/CD pipeline
* [ ] Improved responsive UI
* [ ] Production-grade database security

---

## 🎯 Learning Outcomes

This project demonstrates practical experience with:

* Java web application development
* Servlet-based backend architecture
* JSP-based frontend development
* JDBC and relational database integration
* DAO design pattern
* MVC-inspired application structure
* CRUD operations
* Database relationships and foreign keys
* Maven project management
* WAR packaging
* Cloud deployment configuration

---

## 🤝 Contributing

Contributions, suggestions, and improvements are welcome.

1. Fork the repository
2. Create a feature branch

```bash
git checkout -b feature/your-feature
```

3. Commit your changes

```bash
git commit -m "feat: add your feature"
```

4. Push the branch

```bash
git push origin feature/your-feature
```

5. Open a Pull Request

---

## 👨‍💻 Author

**Utkarsh Kumar**

Full-Stack Developer

* GitHub: [@Utkarsh6358](https://github.com/Utkarsh6358)

---

## 📄 License

This project is intended for educational and portfolio purposes.

---

<p align="center">
  Built with ☕ Java, 🗄️ MySQL and a lot of debugging.
</p>
