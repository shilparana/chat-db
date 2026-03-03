-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO destinations (city, country, region, description, average_temperature, best_season, popular_attractions) VALUES
('Paris', 'France', 'Europe', 'The City of Light, famous for art, fashion, and culture', 12.5, 'Spring/Fall', 'Eiffel Tower, Louvre Museum, Notre-Dame'),
('Tokyo', 'Japan', 'Asia', 'Modern metropolis blending tradition and technology', 16.0, 'Spring/Fall', 'Tokyo Tower, Senso-ji Temple, Shibuya Crossing'),
('New York', 'USA', 'North America', 'The city that never sleeps', 13.0, 'Spring/Fall', 'Statue of Liberty, Central Park, Times Square'),
('Dubai', 'UAE', 'Middle East', 'Luxury destination with modern architecture', 27.0, 'Winter', 'Burj Khalifa, Dubai Mall, Palm Jumeirah'),
('Sydney', 'Australia', 'Oceania', 'Harbor city with iconic landmarks', 18.0, 'Spring/Summer', 'Opera House, Harbor Bridge, Bondi Beach'),
('Rome', 'Italy', 'Europe', 'Ancient city with rich history', 15.5, 'Spring/Fall', 'Colosseum, Vatican City, Trevi Fountain'),
('Bali', 'Indonesia', 'Asia', 'Tropical paradise with beaches and temples', 27.0, 'Dry Season', 'Uluwatu Temple, Rice Terraces, Beaches'),
('London', 'UK', 'Europe', 'Historic capital with royal heritage', 11.0, 'Summer', 'Big Ben, Tower of London, British Museum');
INSERT INTO travelers (first_name, last_name, email, phone, passport_number, nationality, date_of_birth, loyalty_points, membership_tier) VALUES
('Emma', 'Thompson', 'emma.t@travel.com', '+1-555-8101', 'US123456789', 'USA', '1985-06-15', 5000, 'gold'),
('James', 'Wilson', 'james.w@travel.com', '+44-555-8102', 'UK987654321', 'UK', '1990-03-22', 3500, 'silver'),
('Sophie', 'Martin', 'sophie.m@travel.com', '+33-555-8103', 'FR456789123', 'France', '1988-11-10', 7500, 'platinum'),
('Lucas', 'Schmidt', 'lucas.s@travel.com', '+49-555-8104', 'DE789123456', 'Germany', '1992-08-05', 2000, 'silver'),
('Olivia', 'Brown', 'olivia.b@travel.com', '+1-555-8105', 'US234567890', 'USA', '1987-12-18', 4200, 'gold');
INSERT INTO hotels (hotel_name, destination_id, address, star_rating, description, check_in_time, check_out_time, phone) VALUES
('Grand Paris Hotel', 1, '123 Champs-Élysées, Paris', 5, 'Luxury hotel in the heart of Paris', '15:00:00', '12:00:00', '+33-1-5555-0101'),
('Tokyo Imperial Hotel', 2, '456 Ginza, Tokyo', 5, 'Premium hotel with traditional Japanese service', '14:00:00', '11:00:00', '+81-3-5555-0102'),
('Manhattan Plaza Hotel', 3, '789 5th Avenue, New York', 4, 'Modern hotel near Central Park', '15:00:00', '12:00:00', '+1-212-555-0103'),
('Dubai Luxury Resort', 4, '321 Sheikh Zayed Road, Dubai', 5, 'Ultra-luxury resort with beach access', '14:00:00', '12:00:00', '+971-4-555-0104'),
('Sydney Harbor Hotel', 5, '654 Circular Quay, Sydney', 4, 'Hotel with stunning harbor views', '14:00:00', '11:00:00', '+61-2-5555-0105');
INSERT INTO rooms (hotel_id, room_type, description, capacity, price_per_night, available_rooms, amenities) VALUES
(1, 'Deluxe Room', 'Spacious room with city view', 2, 350.00, 20, 'WiFi, TV, Mini-bar, Safe'),
(1, 'Suite', 'Luxury suite with Eiffel Tower view', 4, 750.00, 5, 'WiFi, TV, Mini-bar, Safe, Balcony, Jacuzzi'),
(2, 'Standard Room', 'Comfortable room with modern amenities', 2, 280.00, 30, 'WiFi, TV, Tea set'),
(2, 'Executive Suite', 'Premium suite with traditional decor', 3, 650.00, 8, 'WiFi, TV, Tea set, Balcony, Butler service'),
(3, 'City View Room', 'Room overlooking Manhattan', 2, 320.00, 25, 'WiFi, TV, Coffee maker'),
(4, 'Beach Villa', 'Private villa with beach access', 4, 1200.00, 10, 'WiFi, TV, Private pool, Butler'),
(5, 'Harbor View Room', 'Room with Opera House view', 2, 380.00, 18, 'WiFi, TV, Mini-bar');
INSERT INTO flights (flight_number, airline, departure_airport, arrival_airport, departure_time, arrival_time, duration_minutes, aircraft_type, economy_price, business_price, available_seats) VALUES
('AF001', 'Air France', 'JFK New York', 'CDG Paris', '2024-04-15 18:00:00', '2024-04-16 08:00:00', 420, 'Boeing 777', 650.00, 2500.00, 280),
('BA002', 'British Airways', 'LHR London', 'JFK New York', '2024-04-20 10:00:00', '2024-04-20 13:00:00', 480, 'Airbus A380', 700.00, 2800.00, 350),
('EK003', 'Emirates', 'DXB Dubai', 'LHR London', '2024-04-25 03:00:00', '2024-04-25 07:30:00', 450, 'Airbus A380', 550.00, 2200.00, 400),
('JL004', 'Japan Airlines', 'NRT Tokyo', 'LAX Los Angeles', '2024-05-01 16:00:00', '2024-05-01 10:00:00', 600, 'Boeing 787', 800.00, 3200.00, 250),
('QF005', 'Qantas', 'SYD Sydney', 'LAX Los Angeles', '2024-05-10 22:00:00', '2024-05-10 16:00:00', 780, 'Airbus A380', 950.00, 3800.00, 320);
INSERT INTO bookings (booking_reference, traveler_id, total_amount, payment_status, booking_status) VALUES
('BK2024001', 1, 3200.00, 'paid', 'confirmed'),
('BK2024002', 2, 1850.00, 'paid', 'confirmed'),
('BK2024003', 3, 5400.00, 'paid', 'confirmed'),
('BK2024004', 4, 2100.00, 'pending', 'confirmed'),
('BK2024005', 5, 4200.00, 'paid', 'confirmed');
INSERT INTO hotel_bookings (booking_id, room_id, check_in_date, check_out_date, number_of_guests, total_price) VALUES
(1, 2, '2024-04-16', '2024-04-20', 2, 3000.00),
(2, 3, '2024-05-01', '2024-05-05', 2, 1120.00),
(3, 6, '2024-06-10', '2024-06-15', 4, 6000.00);
INSERT INTO flight_bookings (booking_id, flight_id, seat_class, seat_number, passenger_name, ticket_price) VALUES
(1, 1, 'economy', '23A', 'Emma Thompson', 650.00),
(2, 2, 'economy', '15C', 'James Wilson', 700.00),
(3, 3, 'business', '2A', 'Sophie Martin', 2200.00);
INSERT INTO reviews (traveler_id, hotel_id, rating, title, review_text, is_verified, helpful_count) VALUES
(1, 1, 5, 'Amazing stay in Paris!', 'The hotel exceeded all expectations. Beautiful rooms and excellent service.', TRUE, 25),
(2, 2, 4, 'Great hotel in Tokyo', 'Wonderful experience with authentic Japanese hospitality. Highly recommended.', TRUE, 18),
(3, 4, 5, 'Luxury at its finest', 'Absolutely stunning resort. The beach villa was perfect for our family.', TRUE, 32);
INSERT INTO tour_packages (package_name, destination_id, duration_days, description, price_per_person, max_group_size, included_services) VALUES
('Paris Romance Package', 1, 5, 'Romantic getaway with Seine cruise and fine dining', 1500.00, 2, 'Hotel, Breakfast, Seine Cruise, Eiffel Tower dinner'),
('Tokyo Cultural Experience', 2, 7, 'Immersive cultural tour with temples and traditional activities', 2200.00, 10, 'Hotel, Breakfast, Guided tours, Tea ceremony'),
('Dubai Luxury Escape', 4, 4, 'Ultimate luxury experience in Dubai', 3500.00, 4, 'Hotel, All meals, Desert safari, Burj Khalifa tickets'),
('Sydney Adventure', 5, 6, 'Explore Sydney and surroundings', 1800.00, 12, 'Hotel, Breakfast, Harbor cruise, Blue Mountains tour');
