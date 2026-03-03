-- TRAVELERS TABLE: Stores traveler/customer information and loyalty program data
-- Use this table for queries about: traveler names, emails, passport numbers, nationalities, loyalty points, membership tiers, traveler registration
CREATE TABLE travelers (
    traveler_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each traveler
    first_name VARCHAR(100) NOT NULL,                   -- Traveler's first name
    last_name VARCHAR(100) NOT NULL,                    -- Traveler's last name
    email VARCHAR(255) UNIQUE NOT NULL,                 -- Traveler email address (unique)
    phone VARCHAR(20),                                  -- Traveler phone number
    passport_number VARCHAR(50),                        -- Passport number for international travel
    nationality VARCHAR(100),                           -- Traveler's nationality/citizenship
    date_of_birth DATE,                                 -- Date of birth
    loyalty_points INT DEFAULT 0,                       -- Accumulated loyalty program points
    membership_tier VARCHAR(20) DEFAULT 'silver',       -- Membership tier (bronze, silver, gold, platinum)
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- When traveler registered
);

-- DESTINATIONS TABLE: Stores travel destination information and details
-- Use this table for queries about: cities, countries, regions, popular attractions, best seasons, destination descriptions, average temperatures
CREATE TABLE destinations (
    destination_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each destination
    city VARCHAR(100) NOT NULL,                         -- City name
    country VARCHAR(100) NOT NULL,                      -- Country name
    region VARCHAR(100),                                -- Geographic region
    description TEXT,                                   -- Destination description
    average_temperature DECIMAL(5, 2),                  -- Average temperature in Celsius
    best_season VARCHAR(50),                            -- Best season to visit
    popular_attractions TEXT,                           -- List of popular tourist attractions
    is_active BOOLEAN DEFAULT TRUE                      -- Whether destination is currently offered
);

-- HOTELS TABLE: Stores hotel information and amenities
-- Use this table for queries about: hotel names, star ratings, hotel amenities, check-in times, hotel locations, hotel contact info
CREATE TABLE hotels (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each hotel
    hotel_name VARCHAR(255) NOT NULL,                   -- Hotel name
    destination_id INT,                                 -- Destination where hotel is located
    address TEXT,                                       -- Hotel street address
    star_rating INT,                                    -- Star rating (1-5)
    description TEXT,                                   -- Hotel description
    amenities TEXT,                                     -- Available amenities (pool, gym, wifi, etc.)
    check_in_time TIME,                                 -- Standard check-in time
    check_out_time TIME,                                -- Standard check-out time
    phone VARCHAR(20),                                  -- Hotel phone number
    email VARCHAR(255),                                 -- Hotel email address
    FOREIGN KEY (destination_id) REFERENCES destinations(destination_id)
);

-- ROOMS TABLE: Stores hotel room types and pricing
-- Use this table for queries about: room types, room capacity, prices per night, available rooms, room amenities
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,             -- Unique identifier for each room type
    hotel_id INT,                                       -- Hotel this room belongs to
    room_type VARCHAR(100),                             -- Room type (single, double, suite, deluxe)
    description TEXT,                                   -- Room description
    capacity INT,                                       -- Maximum number of guests
    price_per_night DECIMAL(10, 2),                     -- Price per night
    available_rooms INT,                                -- Number of available rooms of this type
    amenities TEXT,                                     -- Room-specific amenities
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

-- FLIGHTS TABLE: Stores flight schedules and pricing
-- Use this table for queries about: flight numbers, airlines, departure/arrival airports, flight times, flight prices, available seats, flight duration, aircraft types
CREATE TABLE flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique identifier for each flight
    flight_number VARCHAR(20) UNIQUE NOT NULL,          -- Flight number (unique)
    airline VARCHAR(100),                               -- Airline name
    departure_airport VARCHAR(100),                     -- Departure airport code/name
    arrival_airport VARCHAR(100),                       -- Arrival airport code/name
    departure_time TIMESTAMP,                           -- Scheduled departure time
    arrival_time TIMESTAMP,                             -- Scheduled arrival time
    duration_minutes INT,                               -- Flight duration in minutes
    aircraft_type VARCHAR(100),                         -- Aircraft model/type
    economy_price DECIMAL(10, 2),                       -- Economy class ticket price
    business_price DECIMAL(10, 2),                      -- Business class ticket price
    first_class_price DECIMAL(10, 2),                   -- First class ticket price
    available_seats INT                                 -- Total available seats
);

-- BOOKINGS TABLE: Stores travel bookings and reservations
-- Use this table for queries about: booking references, booking dates, booking status, total amounts, payment status, traveler bookings
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each booking
    booking_reference VARCHAR(50) UNIQUE NOT NULL,      -- Unique booking reference number
    traveler_id INT,                                    -- Traveler who made the booking
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- When booking was made
    total_amount DECIMAL(12, 2),                        -- Total booking amount
    payment_status VARCHAR(20) DEFAULT 'pending',       -- Payment status (pending, paid, refunded)
    booking_status VARCHAR(20) DEFAULT 'confirmed',     -- Booking status (confirmed, cancelled, completed)
    FOREIGN KEY (traveler_id) REFERENCES travelers(traveler_id)
);

-- HOTEL_BOOKINGS TABLE: Links bookings to hotel rooms
-- Use this table for queries about: hotel reservations, check-in/check-out dates, number of guests, room bookings, special requests
CREATE TABLE hotel_bookings (
    hotel_booking_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique identifier for each hotel booking
    booking_id INT,                                     -- Main booking reference
    room_id INT,                                        -- Room being booked
    check_in_date DATE,                                 -- Check-in date
    check_out_date DATE,                                -- Check-out date,
    number_of_guests INT,                               -- Number of guests staying
    special_requests TEXT,                              -- Special requests (early check-in, extra bed, etc.)
    total_price DECIMAL(10, 2),                         -- Total price for hotel booking
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- FLIGHT_BOOKINGS TABLE: Links bookings to specific flights
-- Use this table for queries about: flight reservations, seat classes, seat numbers, passenger names, ticket prices
CREATE TABLE flight_bookings (
    flight_booking_id INT AUTO_INCREMENT PRIMARY KEY,   -- Unique identifier for each flight booking
    booking_id INT,                                     -- Main booking reference
    flight_id INT,                                      -- Flight being booked
    seat_class VARCHAR(20),                             -- Seat class (economy, business, first_class)
    seat_number VARCHAR(10),                            -- Assigned seat number
    passenger_name VARCHAR(255),                        -- Passenger name
    ticket_price DECIMAL(10, 2),                        -- Ticket price for this passenger
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

-- REVIEWS TABLE: Stores customer hotel reviews and ratings
-- Use this table for queries about: hotel ratings, review text, review dates, verified reviews, helpful counts, traveler feedback
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique identifier for each review
    traveler_id INT,                                    -- Traveler who wrote the review
    hotel_id INT,                                       -- Hotel being reviewed
    rating INT CHECK (rating >= 1 AND rating <= 5),     -- Star rating (1-5)
    title VARCHAR(255),                                 -- Review title/headline
    review_text TEXT,                                   -- Review content/text
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- When review was posted
    is_verified BOOLEAN DEFAULT FALSE,                  -- Whether reviewer actually stayed at hotel
    helpful_count INT DEFAULT 0,                        -- Number of users who found review helpful
    FOREIGN KEY (traveler_id) REFERENCES travelers(traveler_id),
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

-- TOUR_PACKAGES TABLE: Stores tour package offerings
-- Use this table for queries about: package names, package prices, duration, destinations, included services, max group sizes, active packages
CREATE TABLE tour_packages (
    package_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each tour package
    package_name VARCHAR(255) NOT NULL,                 -- Package name/title
    destination_id INT,                                 -- Destination for this package
    duration_days INT,                                  -- Tour duration in days
    description TEXT,                                   -- Package description
    price_per_person DECIMAL(10, 2),                    -- Price per person
    max_group_size INT,                                 -- Maximum group size
    included_services TEXT,                             -- Included services (meals, transport, guides, etc.)
    is_active BOOLEAN DEFAULT TRUE,                     -- Whether package is currently offered
    FOREIGN KEY (destination_id) REFERENCES destinations(destination_id)
);











CREATE INDEX idx_travelers_email ON travelers(email);
CREATE INDEX idx_hotels_destination ON hotels(destination_id);
CREATE INDEX idx_rooms_hotel ON rooms(hotel_id);
CREATE INDEX idx_bookings_traveler ON bookings(traveler_id);
CREATE INDEX idx_hotel_bookings_booking ON hotel_bookings(booking_id);
CREATE INDEX idx_flight_bookings_booking ON flight_bookings(booking_id);
CREATE INDEX idx_reviews_hotel ON reviews(hotel_id);
