-- EMPLOYEES TABLE: Stores employee information and organizational structure
-- Use this table for queries about: employee names, job titles, departments, salaries, hire dates, managers, employee status
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,                 -- Unique identifier for each employee
    first_name VARCHAR(100) NOT NULL,               -- Employee's first name
    last_name VARCHAR(100) NOT NULL,                -- Employee's last name
    email VARCHAR(255) UNIQUE NOT NULL,             -- Employee email address (unique)
    phone VARCHAR(20),                              -- Employee phone number
    hire_date DATE NOT NULL,                        -- Date employee was hired
    job_title VARCHAR(100),                         -- Job title/position
    department VARCHAR(100),                        -- Department name
    salary DECIMAL(12, 2),                          -- Annual salary
    manager_id INTEGER REFERENCES employees(employee_id), -- Employee's manager (self-reference)
    status VARCHAR(20) DEFAULT 'active'             -- Employment status (active, terminated, on_leave)
);

-- ATTENDANCE TABLE: Tracks employee attendance and work hours
-- Use this table for queries about: check-in times, check-out times, hours worked, attendance dates, work schedules
CREATE TABLE attendance (
    attendance_id SERIAL PRIMARY KEY,               -- Unique identifier for each attendance record
    employee_id INTEGER REFERENCES employees(employee_id), -- Employee this record belongs to
    date DATE NOT NULL,                             -- Attendance date
    check_in TIME,                                  -- Time employee checked in
    check_out TIME,                                 -- Time employee checked out
    status VARCHAR(20),                             -- Status (present, absent, late, half_day)
    hours_worked DECIMAL(5, 2)                      -- Total hours worked that day
);

-- LEAVE_REQUESTS TABLE: Manages employee leave and vacation requests
-- Use this table for queries about: vacation requests, sick leave, leave dates, leave status, leave approvals
CREATE TABLE leave_requests (
    leave_id SERIAL PRIMARY KEY,                    -- Unique identifier for each leave request
    employee_id INTEGER REFERENCES employees(employee_id), -- Employee requesting leave
    leave_type VARCHAR(50),                         -- Type (vacation, sick, personal, maternity, etc.)
    start_date DATE NOT NULL,                       -- Leave start date
    end_date DATE NOT NULL,                         -- Leave end date
    days_requested INTEGER,                         -- Number of days requested
    reason TEXT,                                    -- Reason for leave
    status VARCHAR(20) DEFAULT 'pending',           -- Status (pending, approved, rejected)
    approved_by INTEGER REFERENCES employees(employee_id), -- Manager who approved/rejected
    request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- When request was submitted
);

-- PAYROLL TABLE: Stores employee payroll and compensation information
-- Use this table for queries about: gross pay, net pay, deductions, pay periods, payment dates, salary payments
CREATE TABLE payroll (
    payroll_id SERIAL PRIMARY KEY,                  -- Unique identifier for each payroll record
    employee_id INTEGER REFERENCES employees(employee_id), -- Employee being paid
    pay_period_start DATE,                          -- Pay period start date
    pay_period_end DATE,                            -- Pay period end date
    gross_pay DECIMAL(12, 2),                       -- Gross pay before deductions
    deductions DECIMAL(10, 2),                      -- Total deductions (taxes, insurance, etc.)
    net_pay DECIMAL(12, 2),                         -- Net pay after deductions
    payment_date DATE,                              -- Date payment was/will be made
    status VARCHAR(20) DEFAULT 'pending'            -- Status (pending, processed, paid)
);





CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_attendance_employee ON attendance(employee_id);
CREATE INDEX idx_leave_requests_employee ON leave_requests(employee_id);
CREATE INDEX idx_payroll_employee ON payroll(employee_id);
