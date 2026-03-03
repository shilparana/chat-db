-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO companies (company_name, industry, website, phone, email, city, state, country, employee_count, annual_revenue) VALUES
('TechCorp Solutions', 'Technology', 'www.techcorp.com', '+1-555-7001', 'info@techcorp.com', 'San Francisco', 'CA', 'USA', 500, 50000000.00),
('Global Manufacturing Inc', 'Manufacturing', 'www.globalmfg.com', '+1-555-7002', 'contact@globalmfg.com', 'Detroit', 'MI', 'USA', 1200, 150000000.00),
('HealthPlus Medical', 'Healthcare', 'www.healthplus.com', '+1-555-7003', 'info@healthplus.com', 'Boston', 'MA', 'USA', 300, 25000000.00),
('RetailMax Chain', 'Retail', 'www.retailmax.com', '+1-555-7004', 'contact@retailmax.com', 'Chicago', 'IL', 'USA', 2500, 200000000.00),
('FinanceFirst Bank', 'Finance', 'www.financefirst.com', '+1-555-7005', 'info@financefirst.com', 'New York', 'NY', 'USA', 800, 100000000.00);
INSERT INTO contacts (first_name, last_name, email, phone, company, job_title, city, state, country, source, status) VALUES
('John', 'Smith', 'john.smith@techcorp.com', '+1-555-8001', 'TechCorp Solutions', 'CTO', 'San Francisco', 'CA', 'USA', 'referral', 'active'),
('Sarah', 'Johnson', 'sarah.j@globalmfg.com', '+1-555-8002', 'Global Manufacturing Inc', 'VP Operations', 'Detroit', 'MI', 'USA', 'website', 'active'),
('Michael', 'Brown', 'michael.b@healthplus.com', '+1-555-8003', 'HealthPlus Medical', 'Director IT', 'Boston', 'MA', 'USA', 'conference', 'active'),
('Emily', 'Davis', 'emily.d@retailmax.com', '+1-555-8004', 'RetailMax Chain', 'Procurement Manager', 'Chicago', 'IL', 'USA', 'cold_call', 'active'),
('Robert', 'Wilson', 'robert.w@financefirst.com', '+1-555-8005', 'FinanceFirst Bank', 'Technology Lead', 'New York', 'NY', 'USA', 'linkedin', 'active'),
('Lisa', 'Martinez', 'lisa.m@techcorp.com', '+1-555-8006', 'TechCorp Solutions', 'Product Manager', 'San Francisco', 'CA', 'USA', 'referral', 'active'),
('David', 'Anderson', 'david.a@globalmfg.com', '+1-555-8007', 'Global Manufacturing Inc', 'CFO', 'Detroit', 'MI', 'USA', 'email', 'active'),
('Jennifer', 'Taylor', 'jennifer.t@healthplus.com', '+1-555-8008', 'HealthPlus Medical', 'CEO', 'Boston', 'MA', 'USA', 'referral', 'active');
INSERT INTO opportunities (contact_id, company_id, opportunity_name, description, value, stage, probability, expected_close_date, status) VALUES
(1, 1, 'Enterprise Software License', 'Annual software licensing for 500 users', 250000.00, 'proposal', 75, '2024-04-30', 'open'),
(2, 2, 'Manufacturing System Upgrade', 'Complete ERP system implementation', 500000.00, 'negotiation', 60, '2024-05-15', 'open'),
(3, 3, 'Healthcare IT Infrastructure', 'Network and security infrastructure upgrade', 180000.00, 'qualification', 40, '2024-06-30', 'open'),
(4, 4, 'Retail POS System', 'Point of sale system for 100 locations', 350000.00, 'proposal', 70, '2024-05-01', 'open'),
(5, 5, 'Banking Security Solution', 'Cybersecurity platform implementation', 420000.00, 'prospecting', 30, '2024-07-15', 'open'),
(1, 1, 'Cloud Migration Project', 'Migration to cloud infrastructure', 300000.00, 'closed_won', 100, '2024-03-01', 'closed'),
(6, 1, 'Mobile App Development', 'Custom mobile application development', 150000.00, 'qualification', 50, '2024-06-01', 'open');
INSERT INTO activities (contact_id, opportunity_id, activity_type, subject, description, activity_date, duration_minutes, status) VALUES
(1, 1, 'meeting', 'Product Demo', 'Demonstrated software features to technical team', '2024-03-10 14:00:00', 60, 'completed'),
(1, 1, 'call', 'Follow-up Call', 'Discussed pricing and implementation timeline', '2024-03-12 10:00:00', 30, 'completed'),
(2, 2, 'meeting', 'Requirements Gathering', 'Met with stakeholders to gather requirements', '2024-03-08 09:00:00', 120, 'completed'),
(3, 3, 'email', 'Proposal Sent', 'Sent detailed proposal document', '2024-03-11 15:00:00', 15, 'completed'),
(4, 4, 'meeting', 'Site Visit', 'Visited retail locations for assessment', '2024-03-09 11:00:00', 180, 'completed'),
(5, 5, 'call', 'Discovery Call', 'Initial discovery and needs assessment', '2024-03-13 13:00:00', 45, 'completed');
INSERT INTO notes (contact_id, opportunity_id, note_text, created_by) VALUES
(1, 1, 'Client is very interested in the analytics module. Need to emphasize this in proposal.', 'sales_rep_1'),
(2, 2, 'Decision maker wants to see case studies from similar manufacturing companies.', 'sales_rep_2'),
(3, 3, 'Budget approval pending. Follow up in 2 weeks.', 'sales_rep_3'),
(4, 4, 'Competitor is also bidding. Need competitive pricing strategy.', 'sales_rep_4');
INSERT INTO tasks (contact_id, opportunity_id, task_name, description, due_date, priority, status, assigned_to) VALUES
(1, 1, 'Prepare Final Proposal', 'Create comprehensive proposal with pricing', '2024-03-20', 'high', 'in_progress', 'sales_rep_1'),
(2, 2, 'Schedule Executive Meeting', 'Arrange meeting with C-level executives', '2024-03-18', 'high', 'pending', 'sales_rep_2'),
(3, 3, 'Send Case Studies', 'Compile and send relevant healthcare case studies', '2024-03-25', 'medium', 'pending', 'sales_rep_3'),
(4, 4, 'Competitive Analysis', 'Research competitor offerings and pricing', '2024-03-17', 'high', 'in_progress', 'sales_rep_4'),
(5, 5, 'Security Assessment', 'Conduct preliminary security assessment', '2024-03-22', 'medium', 'pending', 'sales_rep_5');
