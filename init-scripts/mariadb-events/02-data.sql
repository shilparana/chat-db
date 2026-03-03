-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO venues (venue_name, address, city, state, country, capacity, venue_type, contact_email, contact_phone, hourly_rate) VALUES
('Grand Convention Center', '100 Convention Plaza', 'Las Vegas', 'NV', 'USA', 5000, 'convention_center', 'info@grandconvention.com', '+1-555-2001', 5000.00),
('Downtown Conference Hall', '200 Business Street', 'San Francisco', 'CA', 'USA', 1000, 'conference_hall', 'bookings@downtownconf.com', '+1-555-2002', 2000.00),
('Riverside Hotel Ballroom', '300 River Road', 'Chicago', 'IL', 'USA', 800, 'hotel_ballroom', 'events@riverside.com', '+1-555-2003', 1500.00),
('Tech Hub Auditorium', '400 Innovation Drive', 'Austin', 'TX', 'USA', 500, 'auditorium', 'contact@techhub.com', '+1-555-2004', 1000.00),
('Skyline Event Space', '500 Tower Avenue', 'New York', 'NY', 'USA', 300, 'event_space', 'info@skylinespace.com', '+1-555-2005', 1200.00);
INSERT INTO event_organizers (organization_name, contact_person, email, phone, website, specialization, rating, total_events) VALUES
('Premier Events Inc', 'Sarah Johnson', 'sarah@premierevents.com', '+1-555-3001', 'www.premierevents.com', 'Corporate Events', 4.8, 150),
('Tech Conference Group', 'Michael Chen', 'michael@techconf.com', '+1-555-3002', 'www.techconf.com', 'Technology Conferences', 4.9, 85),
('Global Expo Organizers', 'Emily Davis', 'emily@globalexpo.com', '+1-555-3003', 'www.globalexpo.com', 'Trade Shows', 4.7, 120),
('Creative Events Co', 'David Wilson', 'david@creativeevents.com', '+1-555-3004', 'www.creativeevents.com', 'Arts & Culture', 4.6, 95),
('Business Summit Planners', 'Lisa Martinez', 'lisa@bizsummit.com', '+1-555-3005', 'www.bizsummit.com', 'Business Conferences', 4.8, 110);
INSERT INTO events (event_name, event_type, description, venue_id, organizer_id, event_date, start_time, end_time, capacity, ticket_price, status) VALUES
('Tech Innovation Summit 2024', 'conference', 'Annual technology innovation conference', 1, 2, '2024-05-15', '09:00:00', '18:00:00', 2000, 299.00, 'scheduled'),
('Digital Marketing Expo', 'expo', 'Latest trends in digital marketing', 2, 1, '2024-06-10', '10:00:00', '17:00:00', 800, 149.00, 'scheduled'),
('Startup Pitch Competition', 'competition', 'Startups pitch to investors', 4, 5, '2024-04-20', '13:00:00', '20:00:00', 400, 50.00, 'scheduled'),
('AI & Machine Learning Conference', 'conference', 'Advances in AI and ML', 1, 2, '2024-07-25', '09:00:00', '18:00:00', 1500, 399.00, 'scheduled'),
('Creative Design Workshop', 'workshop', 'Hands-on design workshop', 5, 4, '2024-05-05', '10:00:00', '16:00:00', 100, 199.00, 'scheduled'),
('Business Leadership Forum', 'forum', 'Leadership strategies for executives', 3, 5, '2024-06-18', '08:00:00', '17:00:00', 600, 499.00, 'scheduled');
INSERT INTO attendees (first_name, last_name, email, phone, company, job_title) VALUES
('John', 'Smith', 'john.smith@company.com', '+1-555-4001', 'Tech Corp', 'Software Engineer'),
('Emma', 'Johnson', 'emma.j@startup.com', '+1-555-4002', 'Startup Inc', 'Product Manager'),
('Michael', 'Brown', 'michael.b@enterprise.com', '+1-555-4003', 'Enterprise Solutions', 'CTO'),
('Sarah', 'Davis', 'sarah.d@marketing.com', '+1-555-4004', 'Marketing Pro', 'Marketing Director'),
('Robert', 'Wilson', 'robert.w@design.com', '+1-555-4005', 'Design Studio', 'Creative Director'),
('Jennifer', 'Taylor', 'jennifer.t@business.com', '+1-555-4006', 'Business Consulting', 'Senior Consultant'),
('David', 'Anderson', 'david.a@tech.com', '+1-555-4007', 'Tech Innovations', 'Lead Developer'),
('Lisa', 'Martinez', 'lisa.m@digital.com', '+1-555-4008', 'Digital Agency', 'CEO');
INSERT INTO registrations (event_id, attendee_id, ticket_type, amount_paid, payment_status, check_in_status) VALUES
(1, 1, 'early_bird', 249.00, 'paid', 'not_checked_in'),
(1, 3, 'regular', 299.00, 'paid', 'not_checked_in'),
(1, 7, 'early_bird', 249.00, 'paid', 'not_checked_in'),
(2, 4, 'regular', 149.00, 'paid', 'not_checked_in'),
(2, 8, 'regular', 149.00, 'paid', 'not_checked_in'),
(3, 2, 'regular', 50.00, 'paid', 'not_checked_in'),
(4, 1, 'vip', 499.00, 'pending', 'not_checked_in'),
(4, 3, 'regular', 399.00, 'paid', 'not_checked_in'),
(5, 5, 'regular', 199.00, 'paid', 'not_checked_in'),
(6, 6, 'regular', 499.00, 'paid', 'not_checked_in');
INSERT INTO speakers (first_name, last_name, email, phone, bio, expertise, company, title) VALUES
('Dr. Alan', 'Turing', 'alan.turing@ai.com', '+1-555-5001', 'Leading AI researcher with 20 years experience', 'Artificial Intelligence, Machine Learning', 'AI Research Lab', 'Chief Scientist'),
('Prof. Grace', 'Hopper', 'grace.hopper@tech.edu', '+1-555-5002', 'Computer science pioneer and educator', 'Computer Science, Programming', 'Tech University', 'Professor'),
('Steve', 'Innovation', 'steve@innovation.com', '+1-555-5003', 'Serial entrepreneur and tech visionary', 'Startups, Innovation, Product Development', 'Innovation Ventures', 'CEO'),
('Maria', 'Marketing', 'maria@marketguru.com', '+1-555-5004', 'Digital marketing expert and author', 'Digital Marketing, Social Media, SEO', 'Marketing Guru Inc', 'CMO'),
('James', 'Design', 'james@designpro.com', '+1-555-5005', 'Award-winning designer and creative director', 'UX/UI Design, Branding', 'Design Pro Studio', 'Creative Director');
INSERT INTO event_speakers (event_id, speaker_id, session_title, session_time, session_duration, speaking_fee) VALUES
(1, 1, 'The Future of AI in Business', '10:00:00', 60, 5000.00),
(1, 2, 'Building Scalable Systems', '14:00:00', 45, 3500.00),
(2, 4, 'Digital Marketing Trends 2024', '11:00:00', 60, 2500.00),
(3, 3, 'From Idea to IPO: Startup Journey', '15:00:00', 90, 4000.00),
(4, 1, 'Deep Learning Applications', '09:30:00', 90, 6000.00),
(5, 5, 'Design Thinking Workshop', '10:30:00', 240, 3000.00);
INSERT INTO sponsors (company_name, contact_person, email, phone, website, industry) VALUES
('Microsoft Corporation', 'Tom Anderson', 'tom@microsoft.com', '+1-555-6001', 'www.microsoft.com', 'Technology'),
('Google LLC', 'Sarah Lee', 'sarah@google.com', '+1-555-6002', 'www.google.com', 'Technology'),
('Amazon Web Services', 'Mike Chen', 'mike@aws.com', '+1-555-6003', 'www.aws.com', 'Cloud Services'),
('Salesforce', 'Emily Davis', 'emily@salesforce.com', '+1-555-6004', 'www.salesforce.com', 'Software'),
('Adobe Systems', 'Robert Wilson', 'robert@adobe.com', '+1-555-6005', 'www.adobe.com', 'Software');
INSERT INTO event_sponsors (event_id, sponsor_id, sponsorship_level, sponsorship_amount, benefits) VALUES
(1, 1, 'platinum', 50000.00, 'Keynote slot, Booth space, Logo on materials'),
(1, 3, 'gold', 25000.00, 'Booth space, Logo on materials'),
(2, 4, 'platinum', 30000.00, 'Keynote slot, Booth space'),
(4, 1, 'platinum', 60000.00, 'Keynote slot, Booth space, Logo on materials'),
(4, 2, 'gold', 30000.00, 'Booth space, Logo on materials'),
(5, 5, 'silver', 10000.00, 'Logo on materials');
INSERT INTO feedback (event_id, attendee_id, rating, comments, would_recommend) VALUES
(1, 1, 5, 'Excellent conference with great speakers and networking opportunities', TRUE),
(1, 3, 4, 'Very informative, would have liked more hands-on sessions', TRUE),
(2, 4, 5, 'Best marketing expo I have attended. Highly recommend!', TRUE);
