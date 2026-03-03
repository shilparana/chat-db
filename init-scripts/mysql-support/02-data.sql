-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO support_agents (first_name, last_name, email, phone, department, skill_level, hire_date, total_tickets_resolved, avg_resolution_time, customer_satisfaction) VALUES
('Alex', 'Thompson', 'alex.t@support.com', '+1-555-4101', 'Technical', 'senior', '2021-01-15', 1250, 45, 4.7),
('Maria', 'Garcia', 'maria.g@support.com', '+1-555-4102', 'Technical', 'senior', '2020-06-20', 1580, 38, 4.8),
('James', 'Wilson', 'james.w@support.com', '+1-555-4103', 'Billing', 'intermediate', '2022-03-10', 890, 52, 4.5),
('Sophie', 'Brown', 'sophie.b@support.com', '+1-555-4104', 'Technical', 'intermediate', '2022-09-05', 720, 48, 4.6),
('Ryan', 'Davis', 'ryan.d@support.com', '+1-555-4105', 'General', 'junior', '2023-01-12', 450, 65, 4.3),
('Emily', 'Martinez', 'emily.m@support.com', '+1-555-4106', 'Technical', 'senior', '2021-08-18', 1320, 42, 4.9),
('Daniel', 'Anderson', 'daniel.a@support.com', '+1-555-4107', 'Billing', 'intermediate', '2022-11-22', 680, 55, 4.4);
INSERT INTO customers (customer_name, email, phone, company, account_type) VALUES
('John Customer', 'john.c@customer.com', '+1-555-5101', 'Customer Corp', 'premium'),
('Sarah Client', 'sarah.c@client.com', '+1-555-5102', 'Client Industries', 'standard'),
('Mike User', 'mike.u@user.com', '+1-555-5103', 'User Solutions', 'premium'),
('Lisa Buyer', 'lisa.b@buyer.com', '+1-555-5104', 'Buyer Enterprises', 'standard'),
('David Account', 'david.a@account.com', '+1-555-5105', 'Account Systems', 'enterprise'),
('Emma Subscriber', 'emma.s@subscriber.com', '+1-555-5106', 'Subscriber Co', 'standard'),
('Robert Member', 'robert.m@member.com', '+1-555-5107', 'Member Group', 'premium'),
('Jennifer Partner', 'jennifer.p@partner.com', '+1-555-5108', 'Partner Alliance', 'enterprise');
INSERT INTO support_tickets (ticket_number, customer_id, assigned_agent_id, subject, description, priority, status, category, resolved_at, resolution_time_minutes) VALUES
('TKT-2024-001', 1, 1, 'Cannot login to account', 'User unable to access account after password reset', 'high', 'resolved', 'Technical', '2024-03-10 11:30:00', 45),
('TKT-2024-002', 2, 3, 'Billing discrepancy', 'Charged twice for monthly subscription', 'medium', 'resolved', 'Billing', '2024-03-11 15:20:00', 120),
('TKT-2024-003', 3, 2, 'Feature not working', 'Export function returns error', 'high', 'in_progress', 'Technical', NULL, NULL),
('TKT-2024-004', 4, 5, 'General inquiry', 'Questions about product features', 'low', 'resolved', 'General', '2024-03-12 10:15:00', 30),
('TKT-2024-005', 5, 6, 'Performance issues', 'Application running slow on mobile', 'medium', 'in_progress', 'Technical', NULL, NULL),
('TKT-2024-006', 1, 1, 'Data sync problem', 'Data not syncing across devices', 'high', 'open', 'Technical', NULL, NULL),
('TKT-2024-007', 6, 4, 'API integration help', 'Need assistance with API setup', 'medium', 'in_progress', 'Technical', NULL, NULL),
('TKT-2024-008', 7, 3, 'Refund request', 'Request refund for unused service', 'medium', 'resolved', 'Billing', '2024-03-13 14:45:00', 90),
('TKT-2024-009', 8, 6, 'Security concern', 'Suspicious activity on account', 'critical', 'in_progress', 'Security', NULL, NULL),
('TKT-2024-010', 2, 2, 'Feature request', 'Requesting new export format', 'low', 'open', 'Feature Request', NULL, NULL);
INSERT INTO ticket_comments (ticket_id, commenter_type, commenter_id, comment_text, is_internal) VALUES
(1, 'agent', 1, 'Investigating the login issue. Checking authentication logs.', TRUE),
(1, 'agent', 1, 'Found the issue. Password reset token expired. Sending new reset link.', FALSE),
(1, 'customer', 1, 'Thank you! I was able to login successfully.', FALSE),
(2, 'agent', 3, 'Reviewing billing records for duplicate charge.', TRUE),
(2, 'agent', 3, 'Confirmed duplicate charge. Processing refund.', FALSE),
(3, 'customer', 3, 'The error occurs when trying to export more than 1000 records.', FALSE),
(3, 'agent', 2, 'Thank you for the details. Escalating to development team.', FALSE);
INSERT INTO knowledge_base (title, content, category, tags, author_id, view_count, helpful_count, is_published) VALUES
('How to Reset Your Password', 'Step-by-step guide to reset your account password...', 'Account Management', 'password,reset,login', 1, 1250, 980, TRUE),
('Understanding Your Bill', 'Detailed explanation of billing components...', 'Billing', 'billing,invoice,charges', 3, 850, 720, TRUE),
('API Integration Guide', 'Complete guide to integrating with our API...', 'Technical', 'api,integration,development', 2, 2100, 1850, TRUE),
('Mobile App Performance Tips', 'Tips to optimize mobile app performance...', 'Technical', 'mobile,performance,optimization', 6, 650, 520, TRUE),
('Security Best Practices', 'Recommended security practices for your account...', 'Security', 'security,safety,protection', 1, 1450, 1280, TRUE);
INSERT INTO customer_feedback (ticket_id, customer_id, agent_id, rating, feedback_text) VALUES
(1, 1, 1, 5, 'Very helpful and quick response. Issue resolved promptly.'),
(2, 2, 3, 4, 'Good service, though it took a bit longer than expected.'),
(4, 4, 5, 5, 'Excellent customer service! Very friendly and informative.'),
(8, 7, 3, 4, 'Refund processed smoothly. Thank you.');
INSERT INTO sla_policies (policy_name, priority, response_time_minutes, resolution_time_minutes) VALUES
('Critical Priority SLA', 'critical', 15, 240),
('High Priority SLA', 'high', 60, 480),
('Medium Priority SLA', 'medium', 240, 1440),
('Low Priority SLA', 'low', 1440, 4320);
