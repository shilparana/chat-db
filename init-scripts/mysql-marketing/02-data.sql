-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO campaigns (campaign_name, campaign_type, description, start_date, end_date, budget, actual_cost, status, target_audience) VALUES
('Spring Sale 2024', 'promotional', 'Spring season promotional campaign', '2024-03-01', '2024-04-30', 50000.00, 32000.00, 'active', 'Existing customers, age 25-45'),
('Product Launch - Widget Pro', 'product_launch', 'New product launch campaign', '2024-04-01', '2024-05-31', 75000.00, 15000.00, 'active', 'Tech professionals, B2B'),
('Summer Newsletter Series', 'email', 'Monthly newsletter campaign', '2024-06-01', '2024-08-31', 10000.00, 0.00, 'planned', 'All subscribers'),
('Brand Awareness Q2', 'brand', 'Social media brand awareness', '2024-04-01', '2024-06-30', 40000.00, 8000.00, 'active', 'General audience, age 18-55'),
('Holiday Special 2024', 'seasonal', 'End of year holiday campaign', '2024-11-01', '2024-12-31', 100000.00, 0.00, 'planned', 'All customer segments');
INSERT INTO email_lists (list_name, description, subscriber_count) VALUES
('Newsletter Subscribers', 'General newsletter subscription list', 15000),
('Product Updates', 'Product announcement and update list', 8500),
('VIP Customers', 'High-value customer list', 2500),
('Trial Users', 'Free trial users list', 5000),
('Webinar Attendees', 'Past webinar participants', 3200);
INSERT INTO subscribers (email, first_name, last_name, phone, company, job_title, source, status) VALUES
('john.marketing@email.com', 'John', 'Marketing', '+1-555-3101', 'Tech Corp', 'Marketing Manager', 'website', 'active'),
('sarah.digital@email.com', 'Sarah', 'Digital', '+1-555-3102', 'Digital Solutions', 'CMO', 'conference', 'active'),
('mike.content@email.com', 'Mike', 'Content', '+1-555-3103', 'Content Inc', 'Content Director', 'referral', 'active'),
('lisa.brand@email.com', 'Lisa', 'Brand', '+1-555-3104', 'Brand Agency', 'Brand Manager', 'linkedin', 'active'),
('david.social@email.com', 'David', 'Social', '+1-555-3105', 'Social Media Co', 'Social Media Manager', 'website', 'active'),
('emma.email@email.com', 'Emma', 'Email', '+1-555-3106', 'Email Marketing', 'Email Specialist', 'webinar', 'active'),
('robert.seo@email.com', 'Robert', 'SEO', '+1-555-3107', 'SEO Experts', 'SEO Manager', 'website', 'active'),
('jennifer.ppc@email.com', 'Jennifer', 'PPC', '+1-555-3108', 'PPC Agency', 'PPC Specialist', 'partner', 'active');
INSERT INTO list_subscriptions (list_id, subscriber_id, status) VALUES
(1, 1, 'active'),
(1, 2, 'active'),
(1, 3, 'active'),
(2, 1, 'active'),
(2, 4, 'active'),
(3, 2, 'active'),
(3, 5, 'active'),
(4, 6, 'active'),
(5, 7, 'active'),
(5, 8, 'active');
INSERT INTO email_campaigns (campaign_id, list_id, subject_line, scheduled_date, sent_date, total_sent, total_opened, total_clicked, status) VALUES
(1, 1, 'Spring Sale - Up to 50% Off!', '2024-03-01 09:00:00', '2024-03-01 09:05:00', 15000, 6750, 2250, 'sent'),
(1, 3, 'Exclusive VIP Spring Offers', '2024-03-05 10:00:00', '2024-03-05 10:03:00', 2500, 1875, 875, 'sent'),
(2, 2, 'Introducing Widget Pro - Revolutionary Features', '2024-04-01 08:00:00', NULL, 0, 0, 0, 'scheduled');
INSERT INTO social_media_posts (campaign_id, platform, post_content, scheduled_time, published_time, impressions, engagements, clicks, shares, status) VALUES
(1, 'facebook', 'Spring is here! Enjoy up to 50% off on selected items. Limited time offer!', '2024-03-01 12:00:00', '2024-03-01 12:01:00', 45000, 2250, 890, 320, 'published'),
(1, 'twitter', 'Spring Sale Alert! 🌸 Save big on your favorite products. Shop now!', '2024-03-01 14:00:00', '2024-03-01 14:02:00', 28000, 1400, 560, 180, 'published'),
(1, 'instagram', 'Spring vibes and amazing deals! Check out our spring collection.', '2024-03-02 10:00:00', '2024-03-02 10:01:00', 62000, 3720, 1240, 450, 'published'),
(2, 'linkedin', 'Excited to announce Widget Pro - the future of productivity tools.', '2024-04-01 09:00:00', NULL, 0, 0, 0, 0, 'scheduled');
INSERT INTO ad_campaigns (campaign_id, platform, ad_name, ad_type, budget, spent, impressions, clicks, conversions, start_date, end_date, status) VALUES
(1, 'google_ads', 'Spring Sale - Search Campaign', 'search', 15000.00, 8500.00, 125000, 6250, 312, '2024-03-01', '2024-04-30', 'active'),
(1, 'facebook_ads', 'Spring Sale - Display Campaign', 'display', 10000.00, 5200.00, 250000, 7500, 225, '2024-03-01', '2024-04-30', 'active'),
(2, 'linkedin_ads', 'Widget Pro Launch - B2B Campaign', 'sponsored', 20000.00, 4500.00, 85000, 2550, 128, '2024-04-01', '2024-05-31', 'active'),
(4, 'instagram_ads', 'Brand Awareness - Video Campaign', 'video', 12000.00, 3000.00, 180000, 5400, 0, '2024-04-01', '2024-06-30', 'active');
INSERT INTO landing_pages (campaign_id, page_name, url, page_views, unique_visitors, conversions, bounce_rate, avg_time_on_page) VALUES
(1, 'Spring Sale Landing Page', 'https://example.com/spring-sale', 25000, 18500, 1850, 32.50, 145),
(2, 'Widget Pro Product Page', 'https://example.com/widget-pro', 8500, 6200, 620, 28.75, 210),
(4, 'Brand Story Page', 'https://example.com/our-story', 12000, 9500, 0, 45.20, 95);
