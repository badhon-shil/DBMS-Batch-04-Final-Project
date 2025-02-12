-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 12, 2025 at 03:04 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hms`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddAppointment` (IN `p_PatientID` INT, IN `p_DoctorID` INT, IN `p_Date` DATETIME)   BEGIN
    INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate) 
    VALUES (p_PatientID, p_DoctorID, p_Date);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `AppointmentID` int(11) NOT NULL,
  `PatientID` int(11) DEFAULT NULL,
  `DoctorID` int(11) DEFAULT NULL,
  `AppointmentDate` datetime NOT NULL,
  `Status` enum('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`AppointmentID`, `PatientID`, `DoctorID`, `AppointmentDate`, `Status`) VALUES
(1, 1, 1, '2025-02-15 10:00:00', 'Scheduled'),
(2, 2, 2, '2025-02-16 11:00:00', 'Scheduled'),
(3, 3, 3, '2025-02-17 14:30:00', 'Scheduled'),
(4, 4, 4, '2025-02-18 09:00:00', 'Scheduled'),
(5, 5, 5, '2025-02-19 15:00:00', 'Scheduled'),
(6, 6, 1, '2025-02-20 12:00:00', 'Scheduled'),
(7, 7, 2, '2025-02-21 10:30:00', 'Scheduled'),
(8, 8, 3, '2025-02-22 13:00:00', 'Scheduled'),
(9, 9, 4, '2025-02-23 16:00:00', 'Scheduled'),
(10, 10, 5, '2025-02-24 09:30:00', 'Scheduled');

-- --------------------------------------------------------

--
-- Table structure for table `billing`
--

CREATE TABLE `billing` (
  `BillID` int(11) NOT NULL,
  `PatientID` int(11) DEFAULT NULL,
  `Amount` decimal(10,2) NOT NULL,
  `PaymentStatus` enum('Paid','Pending') DEFAULT 'Pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `billing`
--

INSERT INTO `billing` (`BillID`, `PatientID`, `Amount`, `PaymentStatus`) VALUES
(1, 1, 200.00, 'Paid'),
(2, 2, 150.00, 'Pending'),
(3, 3, 250.00, 'Paid'),
(4, 4, 300.00, 'Pending'),
(5, 5, 180.00, 'Paid'),
(6, 6, 220.00, 'Pending'),
(7, 7, 170.00, 'Paid'),
(8, 8, 260.00, 'Pending'),
(9, 9, 310.00, 'Paid'),
(10, 10, 190.00, 'Pending');

--
-- Triggers `billing`
--
DELIMITER $$
CREATE TRIGGER `After_Bill_Paid` AFTER UPDATE ON `billing` FOR EACH ROW BEGIN
    IF NEW.PaymentStatus = 'Paid' THEN
        UPDATE Appointments SET Status = 'Completed' WHERE PatientID = NEW.PatientID;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE `doctors` (
  `DoctorID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Specialization` varchar(100) NOT NULL,
  `Phone` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `doctors`
--

INSERT INTO `doctors` (`DoctorID`, `Name`, `Specialization`, `Phone`) VALUES
(1, 'Dr. Robert King', 'Cardiology', '1112233445'),
(2, 'Dr. Laura Green', 'Dermatology', '2233445566'),
(3, 'Dr. James Miller', 'Orthopedics', '3344556677'),
(4, 'Dr. Sarah Thomas', 'Pediatrics', '4455667788'),
(5, 'Dr. David Wilson', 'General Surgery', '5566778899');

-- --------------------------------------------------------

--
-- Table structure for table `medicalrecords`
--

CREATE TABLE `medicalrecords` (
  `RecordID` int(11) NOT NULL,
  `PatientID` int(11) DEFAULT NULL,
  `Diagnosis` text NOT NULL,
  `Treatment` text NOT NULL,
  `DateRecorded` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `medicalrecords`
--

INSERT INTO `medicalrecords` (`RecordID`, `PatientID`, `Diagnosis`, `Treatment`, `DateRecorded`) VALUES
(1, 1, 'High Blood Pressure', 'Medication for hypertension', '2025-02-12 14:03:33'),
(2, 2, 'Skin Rash', 'Topical ointments and creams', '2025-02-12 14:03:33'),
(3, 3, 'Fracture', 'Surgical intervention', '2025-02-12 14:03:33'),
(4, 4, 'Pneumonia', 'Antibiotics and breathing support', '2025-02-12 14:03:33'),
(5, 5, 'Migraine', 'Pain relievers and rest', '2025-02-12 14:03:33'),
(6, 6, 'Heart Disease', 'Cardiac medication and monitoring', '2025-02-12 14:03:33'),
(7, 7, 'Eczema', 'Moisturizing creams and steroids', '2025-02-12 14:03:33'),
(8, 8, 'Broken Leg', 'Cast and physical therapy', '2025-02-12 14:03:33'),
(9, 9, 'Asthma', 'Inhalers and steroids', '2025-02-12 14:03:33'),
(10, 10, 'Gallstones', 'Surgical removal of gallbladder', '2025-02-12 14:03:33');

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE `patients` (
  `PatientID` int(11) NOT NULL,
  `Name` varchar(100) NOT NULL,
  `Age` int(11) DEFAULT NULL CHECK (`Age` > 0),
  `Gender` enum('Male','Female','Other') NOT NULL,
  `Address` text DEFAULT NULL,
  `Phone` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`PatientID`, `Name`, `Age`, `Gender`, `Address`, `Phone`) VALUES
(1, 'John Doe', 34, 'Male', '123 Elm St, Springfield', '1234567890'),
(2, 'Jane Smith', 28, 'Female', '456 Oak St, Springfield', '9876543210'),
(3, 'Samuel Green', 50, 'Male', '789 Pine St, Springfield', '5647382910'),
(4, 'Olivia Brown', 40, 'Female', '101 Maple St, Springfield', '3948571032'),
(5, 'Mia White', 22, 'Female', '202 Birch St, Springfield', '2837462938'),
(6, 'Noah Clark', 65, 'Male', '303 Cedar St, Springfield', '7462938492'),
(7, 'Emma Johnson', 30, 'Female', '404 Walnut St, Springfield', '8392928473'),
(8, 'Liam Harris', 55, 'Male', '505 Redwood St, Springfield', '1827364850'),
(9, 'Ava Lewis', 45, 'Female', '606 Fir St, Springfield', '8473627481'),
(10, 'Sophia Walker', 38, 'Female', '707 Palm St, Springfield', '5627361849');

-- --------------------------------------------------------

--
-- Stand-in structure for view `upcomingappointments`
-- (See below for the actual view)
--
CREATE TABLE `upcomingappointments` (
`AppointmentID` int(11)
,`PatientName` varchar(100)
,`DoctorName` varchar(100)
,`AppointmentDate` datetime
);

-- --------------------------------------------------------

--
-- Structure for view `upcomingappointments`
--
DROP TABLE IF EXISTS `upcomingappointments`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `upcomingappointments`  AS SELECT `a`.`AppointmentID` AS `AppointmentID`, `p`.`Name` AS `PatientName`, `d`.`Name` AS `DoctorName`, `a`.`AppointmentDate` AS `AppointmentDate` FROM ((`appointments` `a` join `patients` `p` on(`a`.`PatientID` = `p`.`PatientID`)) join `doctors` `d` on(`a`.`DoctorID` = `d`.`DoctorID`)) WHERE `a`.`AppointmentDate` > current_timestamp() ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`AppointmentID`),
  ADD KEY `PatientID` (`PatientID`),
  ADD KEY `DoctorID` (`DoctorID`);

--
-- Indexes for table `billing`
--
ALTER TABLE `billing`
  ADD PRIMARY KEY (`BillID`),
  ADD KEY `PatientID` (`PatientID`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
  ADD PRIMARY KEY (`DoctorID`),
  ADD UNIQUE KEY `Phone` (`Phone`);

--
-- Indexes for table `medicalrecords`
--
ALTER TABLE `medicalrecords`
  ADD PRIMARY KEY (`RecordID`),
  ADD KEY `PatientID` (`PatientID`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
  ADD PRIMARY KEY (`PatientID`),
  ADD UNIQUE KEY `Phone` (`Phone`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `AppointmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `billing`
--
ALTER TABLE `billing`
  MODIFY `BillID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
  MODIFY `DoctorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `medicalrecords`
--
ALTER TABLE `medicalrecords`
  MODIFY `RecordID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `patients`
--
ALTER TABLE `patients`
  MODIFY `PatientID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patients` (`PatientID`) ON DELETE CASCADE,
  ADD CONSTRAINT `appointments_ibfk_2` FOREIGN KEY (`DoctorID`) REFERENCES `doctors` (`DoctorID`) ON DELETE CASCADE;

--
-- Constraints for table `billing`
--
ALTER TABLE `billing`
  ADD CONSTRAINT `billing_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patients` (`PatientID`) ON DELETE CASCADE;

--
-- Constraints for table `medicalrecords`
--
ALTER TABLE `medicalrecords`
  ADD CONSTRAINT `medicalrecords_ibfk_1` FOREIGN KEY (`PatientID`) REFERENCES `patients` (`PatientID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
