-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO employees (first_name, last_name, email, phone, hire_date, job_title, department, salary, manager_id) VALUES
('Alice', 'Johnson', 'alice.j@company.com', '+1-555-6001', '2020-01-15', 'CEO', 'Executive', 250000.00, NULL),
('Bob', 'Smith', 'bob.s@company.com', '+1-555-6002', '2020-03-20', 'CTO', 'Technology', 200000.00, 1),
('Carol', 'Williams', 'carol.w@company.com', '+1-555-6003', '2021-05-10', 'Senior Developer', 'Technology', 120000.00, 2),
('David', 'Brown', 'david.b@company.com', '+1-555-6004', '2021-07-15', 'Developer', 'Technology', 95000.00, 2),
('Emma', 'Davis', 'emma.d@company.com', '+1-555-6005', '2022-02-01', 'HR Manager', 'Human Resources', 110000.00, 1),
('Frank', 'Miller', 'frank.m@company.com', '+1-555-6006', '2022-06-20', 'Marketing Manager', 'Marketing', 105000.00, 1),
('Grace', 'Wilson', 'grace.w@company.com', '+1-555-6007', '2023-01-10', 'Sales Representative', 'Sales', 75000.00, 1),
('Henry', 'Moore', 'henry.m@company.com', '+1-555-6008', '2023-03-15', 'Junior Developer', 'Technology', 70000.00, 2),
('Iris', 'Taylor', 'iris.t@company.com', '+1-555-6009', '2023-08-01', 'Accountant', 'Finance', 85000.00, 1),
('Jack', 'Anderson', 'jack.a@company.com', '+1-555-6010', '2024-01-05', 'Support Specialist', 'Customer Support', 60000.00, 1);
INSERT INTO attendance (employee_id, date, check_in, check_out, status, hours_worked) VALUES
(3, '2024-03-01', '09:00:00', '17:30:00', 'present', 8.5),
(4, '2024-03-01', '08:45:00', '17:15:00', 'present', 8.5),
(5, '2024-03-01', '09:15:00', '18:00:00', 'present', 8.75),
(3, '2024-03-04', '09:05:00', '17:35:00', 'present', 8.5),
(4, '2024-03-04', '08:50:00', '17:20:00', 'present', 8.5);
INSERT INTO leave_requests (employee_id, leave_type, start_date, end_date, days_requested, reason, status, approved_by) VALUES
(3, 'vacation', '2024-04-01', '2024-04-05', 5, 'Family vacation', 'approved', 2),
(4, 'sick', '2024-03-10', '2024-03-11', 2, 'Medical appointment', 'approved', 2),
(7, 'vacation', '2024-05-15', '2024-05-20', 6, 'Personal travel', 'pending', NULL);
INSERT INTO payroll (employee_id, pay_period_start, pay_period_end, gross_pay, deductions, net_pay, payment_date, status) VALUES
(3, '2024-02-01', '2024-02-29', 10000.00, 2500.00, 7500.00, '2024-03-05', 'paid'),
(4, '2024-02-01', '2024-02-29', 7916.67, 1979.17, 5937.50, '2024-03-05', 'paid'),
(5, '2024-02-01', '2024-02-29', 9166.67, 2291.67, 6875.00, '2024-03-05', 'paid');
