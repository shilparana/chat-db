-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO patients (first_name, last_name, date_of_birth, gender, blood_type, email, phone, city, state, insurance_provider, insurance_policy_number) VALUES
('John', 'Anderson', '1985-03-15', 'Male', 'A+', 'john.anderson@email.com', '+1-555-1001', 'Boston', 'MA', 'HealthFirst Insurance', 'HF-123456'),
('Mary', 'Thompson', '1990-07-22', 'Female', 'O+', 'mary.thompson@email.com', '+1-555-1002', 'Boston', 'MA', 'MediCare Plus', 'MC-789012'),
('James', 'Garcia', '1978-11-30', 'Male', 'B+', 'james.garcia@email.com', '+1-555-1003', 'Cambridge', 'MA', 'BlueCross Shield', 'BC-345678'),
('Patricia', 'Martinez', '1995-05-18', 'Female', 'AB+', 'patricia.m@email.com', '+1-555-1004', 'Boston', 'MA', 'HealthFirst Insurance', 'HF-901234'),
('Robert', 'Rodriguez', '1982-09-25', 'Male', 'O-', 'robert.r@email.com', '+1-555-1005', 'Somerville', 'MA', 'United Health', 'UH-567890'),
('Linda', 'Wilson', '1988-12-10', 'Female', 'A-', 'linda.w@email.com', '+1-555-1006', 'Boston', 'MA', 'MediCare Plus', 'MC-234567'),
('Michael', 'Lee', '1975-04-08', 'Male', 'B-', 'michael.lee@email.com', '+1-555-1007', 'Cambridge', 'MA', 'BlueCross Shield', 'BC-890123'),
('Jennifer', 'White', '1992-08-14', 'Female', 'AB-', 'jennifer.w@email.com', '+1-555-1008', 'Boston', 'MA', 'HealthFirst Insurance', 'HF-456789'),
('William', 'Harris', '1980-01-20', 'Male', 'A+', 'william.h@email.com', '+1-555-1009', 'Brookline', 'MA', 'United Health', 'UH-012345'),
('Elizabeth', 'Clark', '1987-06-05', 'Female', 'O+', 'elizabeth.c@email.com', '+1-555-1010', 'Boston', 'MA', 'MediCare Plus', 'MC-678901');
INSERT INTO doctors (first_name, last_name, specialization, license_number, email, phone, department, years_of_experience, consultation_fee, joined_date) VALUES
('Sarah', 'Johnson', 'Cardiology', 'MD-12345', 'dr.johnson@hospital.com', '+1-555-2001', 'Cardiology', 15, 250.00, '2010-01-15'),
('David', 'Chen', 'Pediatrics', 'MD-23456', 'dr.chen@hospital.com', '+1-555-2002', 'Pediatrics', 12, 200.00, '2012-03-20'),
('Emily', 'Brown', 'Orthopedics', 'MD-34567', 'dr.brown@hospital.com', '+1-555-2003', 'Orthopedics', 18, 275.00, '2008-06-10'),
('Michael', 'Davis', 'Neurology', 'MD-45678', 'dr.davis@hospital.com', '+1-555-2004', 'Neurology', 20, 300.00, '2006-09-05'),
('Jessica', 'Miller', 'Dermatology', 'MD-56789', 'dr.miller@hospital.com', '+1-555-2005', 'Dermatology', 10, 225.00, '2014-11-12'),
('Christopher', 'Wilson', 'General Practice', 'MD-67890', 'dr.wilson@hospital.com', '+1-555-2006', 'General Medicine', 8, 150.00, '2016-02-18'),
('Amanda', 'Taylor', 'Obstetrics', 'MD-78901', 'dr.taylor@hospital.com', '+1-555-2007', 'Obstetrics', 14, 240.00, '2011-05-22'),
('Daniel', 'Anderson', 'Psychiatry', 'MD-89012', 'dr.anderson@hospital.com', '+1-555-2008', 'Psychiatry', 16, 260.00, '2009-08-30');
INSERT INTO appointments (patient_id, doctor_id, appointment_date, appointment_type, status, reason) VALUES
(1, 1, '2024-03-15 10:00:00', 'consultation', 'completed', 'Chest pain and irregular heartbeat'),
(2, 2, '2024-03-16 14:30:00', 'checkup', 'completed', 'Annual pediatric checkup'),
(3, 3, '2024-03-17 09:00:00', 'consultation', 'scheduled', 'Knee pain after sports injury'),
(4, 5, '2024-03-18 11:00:00', 'consultation', 'scheduled', 'Skin rash and irritation'),
(5, 4, '2024-03-19 15:00:00', 'follow-up', 'scheduled', 'Follow-up for migraine treatment'),
(1, 1, '2024-03-20 10:30:00', 'follow-up', 'scheduled', 'Follow-up cardiac consultation'),
(6, 6, '2024-03-21 13:00:00', 'checkup', 'scheduled', 'General health checkup'),
(7, 3, '2024-03-22 16:00:00', 'consultation', 'scheduled', 'Back pain assessment');
INSERT INTO medical_records (patient_id, doctor_id, visit_date, diagnosis, symptoms, treatment_plan) VALUES
(1, 1, '2024-03-15 10:00:00', 'Atrial Fibrillation', 'Irregular heartbeat, chest discomfort', 'Prescribed beta-blockers, lifestyle modifications, follow-up in 2 weeks'),
(2, 2, '2024-03-16 14:30:00', 'Healthy', 'None', 'Continue regular diet and exercise, next checkup in 6 months');
INSERT INTO prescriptions (patient_id, doctor_id, record_id, medication_name, dosage, frequency, duration_days, instructions) VALUES
(1, 1, 1, 'Metoprolol', '50mg', 'Twice daily', 30, 'Take with food, avoid alcohol'),
(1, 1, 1, 'Aspirin', '81mg', 'Once daily', 30, 'Take in the morning');
INSERT INTO lab_tests (patient_id, doctor_id, test_name, test_type, status) VALUES
(1, 1, 'ECG', 'Cardiac', 'completed'),
(1, 1, 'Blood Panel', 'General', 'completed'),
(3, 3, 'X-Ray Knee', 'Radiology', 'pending'),
(4, 5, 'Allergy Test', 'Dermatology', 'pending');
INSERT INTO billing (patient_id, appointment_id, total_amount, insurance_covered, patient_responsibility, payment_status) VALUES
(1, 1, 450.00, 360.00, 90.00, 'paid'),
(2, 2, 200.00, 180.00, 20.00, 'paid');
INSERT INTO departments (department_name, location, head_doctor_id, phone) VALUES
('Cardiology', 'Building A, Floor 3', 1, '+1-555-3001'),
('Pediatrics', 'Building B, Floor 1', 2, '+1-555-3002'),
('Orthopedics', 'Building A, Floor 2', 3, '+1-555-3003'),
('Neurology', 'Building C, Floor 4', 4, '+1-555-3004'),
('Dermatology', 'Building B, Floor 2', 5, '+1-555-3005');
