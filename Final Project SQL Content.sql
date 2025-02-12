--Create Hospital Management System Database--
CREATE DATABASE hms; 
--Create Patients Table--
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Age INT CHECK (Age > 0),
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Address TEXT,
    Phone VARCHAR(15) UNIQUE NOT NULL
);
--Create Doctors Table--
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Specialization VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL
);
--Create Appointments Table--
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE CASCADE
);
--Create Medical Records Table--
CREATE TABLE MedicalRecords (
    RecordID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    Diagnosis TEXT NOT NULL,
    Treatment TEXT NOT NULL,
    DateRecorded TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE
);
--Create Billing Table--
CREATE TABLE Billing (
    BillID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentStatus ENUM('Paid', 'Pending') DEFAULT 'Pending',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE
);

--Stored Procedures, Triggers, and Views:--
--Stored Procedure: Add New Appointment--
DELIMITER $$
CREATE PROCEDURE AddAppointment(IN p_PatientID INT, IN p_DoctorID INT, IN p_Date DATETIME)
BEGIN
    INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate) 
    VALUES (p_PatientID, p_DoctorID, p_Date);
END $$
DELIMITER ;

--Trigger: Update Payment Status on Billing--
DELIMITER $$
CREATE TRIGGER After_Bill_Paid 
AFTER UPDATE ON Billing
FOR EACH ROW
BEGIN
    IF NEW.PaymentStatus = 'Paid' THEN
        UPDATE Appointments SET Status = 'Completed' WHERE PatientID = NEW.PatientID;
    END IF;
END $$
DELIMITER ;

--View: Upcoming Appointments--
CREATE VIEW UpcomingAppointments AS
SELECT a.AppointmentID, p.Name AS PatientName, d.Name AS DoctorName, a.AppointmentDate 
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE a.AppointmentDate > NOW();


--Inserting demo data--

--Insert Patients--
INSERT INTO Patients (Name, Age, Gender, Address, Phone) VALUES
('John Doe', 34, 'Male', '123 Elm St, Springfield', '1234567890'),
('Jane Smith', 28, 'Female', '456 Oak St, Springfield', '9876543210'),
('Samuel Green', 50, 'Male', '789 Pine St, Springfield', '5647382910'),
('Olivia Brown', 40, 'Female', '101 Maple St, Springfield', '3948571032'),
('Mia White', 22, 'Female', '202 Birch St, Springfield', '2837462938'),
('Noah Clark', 65, 'Male', '303 Cedar St, Springfield', '7462938492'),
('Emma Johnson', 30, 'Female', '404 Walnut St, Springfield', '8392928473'),
('Liam Harris', 55, 'Male', '505 Redwood St, Springfield', '1827364850'),
('Ava Lewis', 45, 'Female', '606 Fir St, Springfield', '8473627481'),
('Sophia Walker', 38, 'Female', '707 Palm St, Springfield', '5627361849');

--Insert Doctors--
INSERT INTO Doctors (Name, Specialization, Phone) VALUES
('Dr. Robert King', 'Cardiology', '1112233445'),
('Dr. Laura Green', 'Dermatology', '2233445566'),
('Dr. James Miller', 'Orthopedics', '3344556677'),
('Dr. Sarah Thomas', 'Pediatrics', '4455667788'),
('Dr. David Wilson', 'General Surgery', '5566778899');

--Insert Appointments--
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate) VALUES
(1, 1, '2025-02-15 10:00:00'),
(2, 2, '2025-02-16 11:00:00'),
(3, 3, '2025-02-17 14:30:00'),
(4, 4, '2025-02-18 09:00:00'),
(5, 5, '2025-02-19 15:00:00'),
(6, 1, '2025-02-20 12:00:00'),
(7, 2, '2025-02-21 10:30:00'),
(8, 3, '2025-02-22 13:00:00'),
(9, 4, '2025-02-23 16:00:00'),
(10, 5, '2025-02-24 09:30:00');

--Insert Medical Records--
INSERT INTO MedicalRecords (PatientID, Diagnosis, Treatment) VALUES
(1, 'High Blood Pressure', 'Medication for hypertension'),
(2, 'Skin Rash', 'Topical ointments and creams'),
(3, 'Fracture', 'Surgical intervention'),
(4, 'Pneumonia', 'Antibiotics and breathing support'),
(5, 'Migraine', 'Pain relievers and rest'),
(6, 'Heart Disease', 'Cardiac medication and monitoring'),
(7, 'Eczema', 'Moisturizing creams and steroids'),
(8, 'Broken Leg', 'Cast and physical therapy'),
(9, 'Asthma', 'Inhalers and steroids'),
(10, 'Gallstones', 'Surgical removal of gallbladder');

--Insert Billing Data--
INSERT INTO Billing (PatientID, Amount, PaymentStatus) VALUES
(1, 200.00, 'Paid'),
(2, 150.00, 'Pending'),
(3, 250.00, 'Paid'),
(4, 300.00, 'Pending'),
(5, 180.00, 'Paid'),
(6, 220.00, 'Pending'),
(7, 170.00, 'Paid'),
(8, 260.00, 'Pending'),
(9, 310.00, 'Paid'),
(10, 190.00, 'Pending');