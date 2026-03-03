-- PATIENTS TABLE: Stores patient demographic and contact information
-- Use this table for queries about: patient names, dates of birth, contact info, blood types, insurance information, emergency contacts
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,                  -- Unique identifier for each patient
    first_name VARCHAR(100) NOT NULL,               -- Patient's first name
    last_name VARCHAR(100) NOT NULL,                -- Patient's last name
    date_of_birth DATE NOT NULL,                    -- Patient's date of birth
    gender VARCHAR(20),                             -- Patient's gender
    blood_type VARCHAR(5),                          -- Blood type (A+, B-, O+, etc.)
    email VARCHAR(255),                             -- Patient email address
    phone VARCHAR(20),                              -- Patient phone number
    address TEXT,                                   -- Street address
    city VARCHAR(100),                              -- City
    state VARCHAR(50),                              -- State/province
    postal_code VARCHAR(20),                        -- Postal/ZIP code
    emergency_contact_name VARCHAR(255),            -- Emergency contact person name
    emergency_contact_phone VARCHAR(20),            -- Emergency contact phone
    insurance_provider VARCHAR(255),                -- Insurance company name
    insurance_policy_number VARCHAR(100),           -- Insurance policy number
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When patient registered
    is_active BOOLEAN DEFAULT TRUE                  -- Whether patient record is active
);

-- DOCTORS TABLE: Stores physician information and specializations
-- Use this table for queries about: doctor names, specializations, departments, consultation fees, availability, experience
CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,                   -- Unique identifier for each doctor
    first_name VARCHAR(100) NOT NULL,               -- Doctor's first name
    last_name VARCHAR(100) NOT NULL,                -- Doctor's last name
    specialization VARCHAR(100) NOT NULL,           -- Medical specialization (Cardiology, Pediatrics, etc.)
    license_number VARCHAR(50) UNIQUE NOT NULL,     -- Medical license number (unique)
    email VARCHAR(255),                             -- Doctor email address
    phone VARCHAR(20),                              -- Doctor phone number
    department VARCHAR(100),                        -- Hospital department
    years_of_experience INTEGER,                    -- Years of medical practice
    consultation_fee DECIMAL(8, 2),                 -- Fee per consultation
    is_available BOOLEAN DEFAULT TRUE,              -- Whether doctor is accepting patients
    joined_date DATE                                -- Date joined hospital
);

-- APPOINTMENTS TABLE: Stores scheduled patient appointments with doctors
-- Use this table for queries about: appointment dates, appointment status, doctors, patients, appointment types
CREATE TABLE appointments (
    appointment_id SERIAL PRIMARY KEY,              -- Unique identifier for each appointment
    patient_id INTEGER REFERENCES patients(patient_id), -- Patient for this appointment
    doctor_id INTEGER REFERENCES doctors(doctor_id), -- Doctor for this appointment
    appointment_date TIMESTAMP NOT NULL,            -- Scheduled date and time
    duration_minutes INTEGER DEFAULT 30,            -- Appointment duration in minutes
    appointment_type VARCHAR(50),                   -- Type (consultation, checkup, follow-up)
    status VARCHAR(20) DEFAULT 'scheduled',         -- Status (scheduled, completed, cancelled, no-show)
    reason TEXT,                                    -- Reason for visit
    notes TEXT,                                     -- Additional notes
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP  -- When appointment was booked
);

-- MEDICAL_RECORDS TABLE: Stores patient visit records and diagnoses
-- Use this table for queries about: diagnoses, symptoms, treatment plans, visit dates, medical history
CREATE TABLE medical_records (
    record_id SERIAL PRIMARY KEY,                   -- Unique identifier for each medical record
    patient_id INTEGER REFERENCES patients(patient_id), -- Patient this record belongs to
    doctor_id INTEGER REFERENCES doctors(doctor_id), -- Doctor who created the record
    visit_date TIMESTAMP NOT NULL,                  -- Date and time of visit
    diagnosis TEXT,                                 -- Medical diagnosis
    symptoms TEXT,                                  -- Reported symptoms
    treatment_plan TEXT,                            -- Prescribed treatment plan
    notes TEXT,                                     -- Additional clinical notes
    follow_up_date DATE                             -- Recommended follow-up date
);

-- PRESCRIPTIONS TABLE: Stores medication prescriptions for patients
-- Use this table for queries about: medications, dosages, prescription dates, refills, treatment instructions
CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,             -- Unique identifier for each prescription
    patient_id INTEGER REFERENCES patients(patient_id), -- Patient receiving prescription
    doctor_id INTEGER REFERENCES doctors(doctor_id), -- Doctor who prescribed
    record_id INTEGER REFERENCES medical_records(record_id), -- Related medical record
    medication_name VARCHAR(255) NOT NULL,          -- Name of medication
    dosage VARCHAR(100),                            -- Dosage amount (e.g., 50mg, 10ml)
    frequency VARCHAR(100),                         -- How often to take (e.g., twice daily)
    duration_days INTEGER,                          -- Treatment duration in days
    instructions TEXT,                              -- Special instructions
    prescribed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When prescription was written
    refills_allowed INTEGER DEFAULT 0               -- Number of refills allowed
);

-- LAB_TESTS TABLE: Stores laboratory test orders and results
-- Use this table for queries about: test names, test types, test results, test status, pending tests
CREATE TABLE lab_tests (
    test_id SERIAL PRIMARY KEY,                     -- Unique identifier for each lab test
    patient_id INTEGER REFERENCES patients(patient_id), -- Patient being tested
    doctor_id INTEGER REFERENCES doctors(doctor_id), -- Doctor who ordered the test
    test_name VARCHAR(255) NOT NULL,                -- Name of the test
    test_type VARCHAR(100),                         -- Type (Cardiac, General, Radiology, etc.)
    ordered_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When test was ordered
    completed_date TIMESTAMP,                       -- When test was completed
    results TEXT,                                   -- Test results
    status VARCHAR(20) DEFAULT 'pending',           -- Status (pending, in_progress, completed)
    lab_technician VARCHAR(255)                     -- Technician who performed test
);

-- BILLING TABLE: Stores medical billing and payment information
-- Use this table for queries about: bill amounts, insurance coverage, patient payments, payment status
CREATE TABLE billing (
    billing_id SERIAL PRIMARY KEY,                  -- Unique identifier for each bill
    patient_id INTEGER REFERENCES patients(patient_id), -- Patient being billed
    appointment_id INTEGER REFERENCES appointments(appointment_id), -- Related appointment
    total_amount DECIMAL(10, 2) NOT NULL,           -- Total bill amount
    insurance_covered DECIMAL(10, 2),               -- Amount covered by insurance
    patient_responsibility DECIMAL(10, 2),          -- Amount patient must pay
    payment_status VARCHAR(20) DEFAULT 'pending',   -- Status (pending, paid, overdue)
    billing_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When bill was generated
    payment_date TIMESTAMP,                         -- When payment was received
    payment_method VARCHAR(50)                      -- Payment method used
);

-- DEPARTMENTS TABLE: Stores hospital department information
-- Use this table for queries about: department names, locations, department heads, contact info
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,               -- Unique identifier for each department
    department_name VARCHAR(100) NOT NULL,          -- Department name
    location VARCHAR(255),                          -- Physical location in hospital
    head_doctor_id INTEGER REFERENCES doctors(doctor_id), -- Department head doctor
    phone VARCHAR(20),                              -- Department phone number
    description TEXT                                -- Department description
);









CREATE INDEX idx_patients_email ON patients(email);
CREATE INDEX idx_doctors_specialization ON doctors(specialization);
CREATE INDEX idx_appointments_patient ON appointments(patient_id);
CREATE INDEX idx_appointments_doctor ON appointments(doctor_id);
CREATE INDEX idx_appointments_date ON appointments(appointment_date);
CREATE INDEX idx_medical_records_patient ON medical_records(patient_id);
CREATE INDEX idx_prescriptions_patient ON prescriptions(patient_id);
CREATE INDEX idx_lab_tests_patient ON lab_tests(patient_id);
