-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO accounts (account_number, account_type, customer_name, customer_email, balance, status, opened_date, interest_rate, branch_code) VALUES
('ACC-1001-2024', 'savings', 'Alice Johnson', 'alice.j@email.com', 25000.00, 'active', '2023-01-15', 2.50, 'BR-001'),
('ACC-1002-2024', 'checking', 'Bob Williams', 'bob.w@email.com', 8500.50, 'active', '2023-03-20', 0.50, 'BR-001'),
('ACC-1003-2024', 'savings', 'Carol Martinez', 'carol.m@email.com', 45000.00, 'active', '2022-11-10', 2.75, 'BR-002'),
('ACC-1004-2024', 'checking', 'David Lee', 'david.l@email.com', 3200.75, 'active', '2024-01-05', 0.50, 'BR-003'),
('ACC-1005-2024', 'savings', 'Emma Davis', 'emma.d@email.com', 67500.00, 'active', '2021-06-18', 3.00, 'BR-002'),
('ACC-1006-2024', 'business', 'Tech Solutions Inc', 'info@techsol.com', 125000.00, 'active', '2022-08-22', 1.50, 'BR-001'),
('ACC-1007-2024', 'checking', 'Frank Miller', 'frank.m@email.com', 5600.25, 'active', '2023-09-14', 0.50, 'BR-003'),
('ACC-1008-2024', 'savings', 'Grace Taylor', 'grace.t@email.com', 38000.00, 'active', '2023-04-30', 2.50, 'BR-002'),
('ACC-1009-2024', 'checking', 'Henry Wilson', 'henry.w@email.com', 12000.00, 'active', '2024-02-11', 0.50, 'BR-001'),
('ACC-1010-2024', 'savings', 'Iris Brown', 'iris.b@email.com', 52000.00, 'active', '2022-12-05', 2.75, 'BR-003');
INSERT INTO transactions (account_id, transaction_type, amount, balance_after, description, reference_number, merchant_name, category) VALUES
(1, 'deposit', 5000.00, 25000.00, 'Salary deposit', 'TXN-2024-001', 'Employer Corp', 'income'),
(1, 'withdrawal', 500.00, 24500.00, 'ATM withdrawal', 'TXN-2024-002', 'ATM-Branch-001', 'cash'),
(2, 'purchase', 125.50, 8375.00, 'Grocery shopping', 'TXN-2024-003', 'SuperMart', 'groceries'),
(2, 'deposit', 2000.00, 10375.00, 'Check deposit', 'TXN-2024-004', NULL, 'deposit'),
(3, 'transfer', 1000.00, 44000.00, 'Transfer to checking', 'TXN-2024-005', NULL, 'transfer'),
(4, 'purchase', 85.75, 3115.00, 'Restaurant', 'TXN-2024-006', 'Fine Dining', 'dining'),
(5, 'deposit', 10000.00, 77500.00, 'Investment return', 'TXN-2024-007', 'Investment Co', 'investment'),
(6, 'purchase', 5000.00, 120000.00, 'Office supplies', 'TXN-2024-008', 'Office Depot', 'business'),
(7, 'withdrawal', 200.00, 5400.25, 'ATM withdrawal', 'TXN-2024-009', 'ATM-Branch-003', 'cash'),
(8, 'deposit', 3000.00, 41000.00, 'Freelance payment', 'TXN-2024-010', 'Client ABC', 'income');
INSERT INTO loans (account_id, loan_type, principal_amount, interest_rate, term_months, monthly_payment, outstanding_balance, start_date, status, purpose) VALUES
(1, 'personal', 15000.00, 7.5, 36, 465.00, 12000.00, '2023-06-01', 'active', 'Home renovation'),
(3, 'mortgage', 250000.00, 4.5, 360, 1267.00, 240000.00, '2022-01-15', 'active', 'Home purchase'),
(5, 'auto', 35000.00, 5.5, 60, 668.00, 28000.00, '2023-03-10', 'active', 'Car purchase'),
(6, 'business', 100000.00, 6.0, 120, 1110.00, 85000.00, '2022-09-01', 'active', 'Business expansion'),
(8, 'personal', 10000.00, 8.0, 24, 452.00, 5000.00, '2023-11-20', 'active', 'Debt consolidation');
INSERT INTO loan_payments (loan_id, payment_date, payment_amount, principal_paid, interest_paid, remaining_balance, payment_status) VALUES
(1, '2024-01-01', 465.00, 390.00, 75.00, 11610.00, 'completed'),
(1, '2024-02-01', 465.00, 392.00, 73.00, 11218.00, 'completed'),
(2, '2024-01-01', 1267.00, 330.00, 937.00, 239670.00, 'completed'),
(3, '2024-01-01', 668.00, 540.00, 128.00, 27460.00, 'completed'),
(4, '2024-01-01', 1110.00, 685.00, 425.00, 84315.00, 'completed');
INSERT INTO investments (account_id, investment_type, asset_name, quantity, purchase_price, current_price, purchase_date, status) VALUES
(1, 'stocks', 'Tech Corp', 100.00, 50.00, 65.00, '2023-01-10', 'active'),
(3, 'bonds', 'Government Bond 10Y', 50.00, 1000.00, 1050.00, '2022-06-15', 'active'),
(5, 'mutual_fund', 'Growth Fund A', 500.00, 25.00, 32.00, '2023-02-20', 'active'),
(6, 'stocks', 'Energy Inc', 200.00, 75.00, 82.00, '2022-11-05', 'active'),
(8, 'etf', 'Index ETF 500', 150.00, 120.00, 135.00, '2023-08-12', 'active');
INSERT INTO credit_cards (account_id, card_number, card_type, credit_limit, available_credit, interest_rate, issue_date, expiry_date, status, rewards_points) VALUES
(1, '4532-1234-5678-9010', 'platinum', 10000.00, 7500.00, 18.99, '2023-01-01', '2027-01-01', 'active', 15000),
(2, '5425-2345-6789-0123', 'gold', 5000.00, 4200.00, 19.99, '2023-03-15', '2027-03-15', 'active', 8500),
(4, '3782-3456-7890-1234', 'standard', 3000.00, 2850.00, 21.99, '2024-01-10', '2028-01-10', 'active', 2100),
(7, '6011-4567-8901-2345', 'platinum', 15000.00, 12000.00, 17.99, '2023-09-20', '2027-09-20', 'active', 22000);
