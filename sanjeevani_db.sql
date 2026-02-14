CREATE DATABASE IF NOT EXISTS `sanjeevani` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `sanjeevani`;

-- Disable foreign key checks temporarily
SET FOREIGN_KEY_CHECKS = 0;

-- =====================================================
-- Drop tables in reverse order (children first, parents last)
-- =====================================================
DROP TABLE IF EXISTS `lab_results`;
DROP TABLE IF EXISTS `feedback`;
DROP TABLE IF EXISTS `appointments`;
DROP TABLE IF EXISTS `doctors`;
DROP TABLE IF EXISTS `patients`;

-- =====================================================
-- Create parent tables first
-- =====================================================

-- Table structure for table `patients`
CREATE TABLE `patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `dob` date DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `patients`
INSERT INTO `patients` VALUES
  (9,'shashwat','Shashwat Singh','2004-06-10','boys hostel, 307','6454982469','shashwat123'),
  (10,'utkarsh','Utkarsh Kumar','2004-07-16','boys hostel, 315','6565465684','utkarsh123'),
  (11,'patient1','patient1','2004-06-18','Boys Hostel, 315','4654313546','pat123');

-- Table structure for table `doctors`
CREATE TABLE `doctors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `doctor` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `specialization` varchar(100) DEFAULT NULL,
  `contact` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_email` (`email`),
  UNIQUE KEY `unique_doctor_name` (`doctor`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `doctors`
INSERT INTO `doctors` VALUES 
  (15,'arjun.mehta@example.com','Dr. Arjun Mehta','arjun123','Pediatrics','+91-9876543210'),
  (16,'priya.sharma@example.com','Dr. Priya Sharma','priya123','Dermatology','+91-9123456780'),
  (17,'rakesh.nair@example.com','Dr. Rakesh Nair','rakesh000','Orthopedics','+91-9988776655'),
  (18,'sneha.reddy@example.com','Dr. Sneha Reddy','sneha123','Ophthalmology','+91-9090909090'),
  (19,'anil.kapoor@example.com','Dr. Anil Kapoor','anil123','General Medicine','+91-9012345678'),
  (20,'kavita.joshi@example.com','Dr. Kavita Joshi','kavita123','ENT Specialist','+91-9023456789'),
  (21,'sameer.khan@example.com','Dr. Sameer Khan','sameer123','Cardiology','+91-9000000001'),
  (22,'neha.verma@example.com','Dr. Neha Verma','neha123','Neurology','+91-9000000002');

-- =====================================================
-- Create child tables (with foreign key dependencies)
-- =====================================================

-- Table structure for table `appointments`
CREATE TABLE `appointments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `doctor` varchar(100) DEFAULT NULL,
  `appointment_date` date DEFAULT NULL,
  `appointment_time` time DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  KEY `doctor` (`doctor`),
  CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`username`) REFERENCES `patients` (`username`),
  CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`doctor`) REFERENCES `doctors` (`doctor`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `appointments`
INSERT INTO `appointments` VALUES 
  (3,'shashwat','Dr. Sneha Reddy','2025-05-26','09:08:00','ache'),
  (7,'utkarsh','Dr. Priya Sharma','2025-05-28','14:02:00','fever'),
  (8,'shashwat','Dr. Priya Sharma','2025-05-28','16:06:00','hsavhgv\r\n'),
  (9,'utkarsh','Dr. Priya Sharma','2025-05-28','09:57:00','ache in stomach'),
  (10,'shashwat','Dr. Rakesh Nair','2025-09-10','16:24:00','n');

-- Table structure for table `feedback`
CREATE TABLE `feedback` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `feedback_text` text NOT NULL,
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `username` (`username`),
  CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`username`) REFERENCES `patients` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table `feedback`
INSERT INTO `feedback` VALUES
  (5,'shashwat','hi','2025-05-24 17:48:40'),
  (6,'utkarsh','bye','2025-05-27 08:33:09'),
  (8,'shashwat','hello','2025-05-27 08:45:07');

-- Table structure for table `lab_results`
CREATE TABLE IF NOT EXISTS `lab_results` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_username` varchar(50) NOT NULL,
  `test_name` varchar(100) NOT NULL,
  `test_date` date NOT NULL,
  `result` varchar(50) NOT NULL,
  `comments` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `patient_username` (`patient_username`),
  CONSTRAINT `lab_results_ibfk_1` FOREIGN KEY (`patient_username`) REFERENCES `patients` (`username`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Remove all the problematic OLD_* variable settings at the end
-- No need to set time_zone, sql_mode, etc. as they use system defaults