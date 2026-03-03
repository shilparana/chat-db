-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO agents (first_name, last_name, email, phone, license_number, specialization, years_experience, total_sales, total_volume, rating) VALUES
('Michael', 'Roberts', 'michael.r@realty.com', '+1-555-9101', 'RE-12345', 'Luxury Homes', 15, 125, 45000000.00, 4.9),
('Sarah', 'Johnson', 'sarah.j@realty.com', '+1-555-9102', 'RE-23456', 'Residential', 10, 98, 28000000.00, 4.7),
('David', 'Chen', 'david.c@realty.com', '+1-555-9103', 'RE-34567', 'Commercial', 12, 45, 65000000.00, 4.8),
('Emily', 'Martinez', 'emily.m@realty.com', '+1-555-9104', 'RE-45678', 'Condos', 8, 87, 22000000.00, 4.6),
('James', 'Wilson', 'james.w@realty.com', '+1-555-9105', 'RE-56789', 'Investment Properties', 14, 110, 38000000.00, 4.8);
INSERT INTO properties (property_type, listing_type, address, city, state, country, postal_code, price, bedrooms, bathrooms, square_feet, lot_size, year_built, status, listed_date, features, parking_spaces) VALUES
('Single Family', 'sale', '123 Oak Street', 'Los Angeles', 'CA', 'USA', '90001', 1250000.00, 4, 3.5, 3200, 8000, 2015, 'available', '2024-03-01', 'Pool, Modern Kitchen, Hardwood Floors', 2),
('Condo', 'sale', '456 Park Avenue', 'New York', 'NY', 'USA', '10001', 850000.00, 2, 2.0, 1400, 0, 2018, 'available', '2024-03-05', 'Doorman, Gym, City Views', 1),
('Townhouse', 'sale', '789 Elm Drive', 'San Francisco', 'CA', 'USA', '94102', 1650000.00, 3, 2.5, 2200, 2000, 2020, 'available', '2024-02-28', 'Rooftop Deck, Smart Home, Garage', 2),
('Single Family', 'sale', '321 Maple Lane', 'Miami', 'FL', 'USA', '33101', 2100000.00, 5, 4.0, 4500, 12000, 2019, 'under_contract', '2024-02-15', 'Waterfront, Pool, Guest House', 3),
('Commercial', 'lease', '654 Business Blvd', 'Chicago', 'IL', 'USA', '60601', 15000.00, 0, 2.0, 5000, 0, 2010, 'available', '2024-03-10', 'Office Space, Parking, Conference Rooms', 10),
('Condo', 'sale', '987 Beach Road', 'Miami', 'FL', 'USA', '33139', 725000.00, 2, 2.0, 1200, 0, 2021, 'available', '2024-03-12', 'Ocean View, Balcony, Pool Access', 1),
('Single Family', 'sale', '147 Hill Street', 'Seattle', 'WA', 'USA', '98101', 980000.00, 3, 2.5, 2400, 6000, 2017, 'sold', '2024-01-20', 'Mountain Views, Updated Kitchen', 2),
('Luxury Villa', 'sale', '258 Estate Drive', 'Beverly Hills', 'CA', 'USA', '90210', 8500000.00, 6, 7.0, 8000, 25000, 2022, 'available', '2024-03-08', 'Pool, Tennis Court, Wine Cellar, Theater', 4);
INSERT INTO clients (first_name, last_name, email, phone, client_type, budget_min, budget_max, preferred_locations) VALUES
('Robert', 'Anderson', 'robert.a@email.com', '+1-555-1201', 'buyer', 800000.00, 1200000.00, 'Los Angeles, San Francisco'),
('Jennifer', 'Taylor', 'jennifer.t@email.com', '+1-555-1202', 'buyer', 600000.00, 900000.00, 'New York, Brooklyn'),
('William', 'Brown', 'william.b@email.com', '+1-555-1203', 'seller', 0, 0, 'Miami'),
('Lisa', 'Davis', 'lisa.d@email.com', '+1-555-1204', 'buyer', 1500000.00, 2000000.00, 'San Francisco, Palo Alto'),
('Thomas', 'Miller', 'thomas.m@email.com', '+1-555-1205', 'buyer', 2000000.00, 3000000.00, 'Miami, Fort Lauderdale'),
('Patricia', 'Wilson', 'patricia.w@email.com', '+1-555-1206', 'seller', 0, 0, 'Seattle'),
('Charles', 'Moore', 'charles.m@email.com', '+1-555-1207', 'buyer', 5000000.00, 10000000.00, 'Beverly Hills, Malibu');
INSERT INTO property_listings (property_id, agent_id, listing_price, commission_rate, listing_date, expiry_date, status) VALUES
(1, 1, 1250000.00, 5.0, '2024-03-01', '2024-09-01', 'active'),
(2, 4, 850000.00, 5.5, '2024-03-05', '2024-09-05', 'active'),
(3, 2, 1650000.00, 5.0, '2024-02-28', '2024-08-28', 'active'),
(4, 1, 2100000.00, 5.0, '2024-02-15', '2024-08-15', 'under_contract'),
(5, 3, 15000.00, 10.0, '2024-03-10', '2025-03-10', 'active'),
(6, 4, 725000.00, 5.5, '2024-03-12', '2024-09-12', 'active'),
(7, 2, 980000.00, 5.0, '2024-01-20', '2024-07-20', 'sold'),
(8, 1, 8500000.00, 4.5, '2024-03-08', '2024-09-08', 'active');
INSERT INTO viewings (property_id, client_id, agent_id, viewing_date, status, feedback, interest_level) VALUES
(1, 1, 1, '2024-03-10 14:00:00', 'completed', 'Client loved the pool and modern kitchen', 'high'),
(2, 2, 4, '2024-03-12 11:00:00', 'completed', 'Interested but concerned about HOA fees', 'medium'),
(3, 4, 2, '2024-03-08 15:00:00', 'completed', 'Very interested, wants to make an offer', 'high'),
(4, 5, 1, '2024-03-05 10:00:00', 'completed', 'Perfect for their needs, submitted offer', 'high'),
(8, 7, 1, '2024-03-14 13:00:00', 'scheduled', NULL, NULL);
INSERT INTO offers (property_id, client_id, agent_id, offer_amount, offer_date, status, response_date, counter_offer_amount) VALUES
(4, 5, 1, 2050000.00, '2024-03-06', 'accepted', '2024-03-07', NULL),
(3, 4, 2, 1600000.00, '2024-03-09', 'countered', '2024-03-10', 1625000.00),
(1, 1, 1, 1200000.00, '2024-03-11', 'pending', NULL, NULL);
INSERT INTO transactions (property_id, buyer_id, seller_id, listing_agent_id, buying_agent_id, sale_price, sale_date, commission_amount, closing_costs, status) VALUES
(7, 6, 6, 2, 2, 980000.00, '2024-03-01', 49000.00, 15000.00, 'completed'),
(4, 5, 3, 1, 1, 2050000.00, '2024-03-15', 102500.00, 28000.00, 'in_progress');
