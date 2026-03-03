-- VENUES TABLE: Stores event venue information
-- Use this table for queries about: venue names, venue capacity, venue types, venue amenities, venue locations, hourly rates, venue contact info
CREATE TABLE venues (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each venue
    venue_name VARCHAR(255) NOT NULL,                   -- Venue name
    address TEXT,                                       -- Street address
    city VARCHAR(100),                                  -- City
    state VARCHAR(50),                                  -- State/province
    country VARCHAR(100),                               -- Country
    postal_code VARCHAR(20),                            -- Postal/ZIP code
    capacity INT,                                       -- Maximum capacity (number of people)
    venue_type VARCHAR(50),                             -- Type (conference_center, hotel, outdoor, theater)
    amenities TEXT,                                     -- Available amenities (AV equipment, catering, parking)
    contact_email VARCHAR(255),                         -- Venue contact email
    contact_phone VARCHAR(20),                          -- Venue contact phone
    hourly_rate DECIMAL(10, 2),                         -- Hourly rental rate
    is_active BOOLEAN DEFAULT TRUE                      -- Whether venue is currently available
);

-- EVENT_ORGANIZERS TABLE: Stores event organizer/company information
-- Use this table for queries about: organization names, contact persons, organizer emails, specializations, organizer ratings, total events organized
CREATE TABLE event_organizers (
    organizer_id INT AUTO_INCREMENT PRIMARY KEY,        -- Unique identifier for each organizer
    organization_name VARCHAR(255) NOT NULL,            -- Organization/company name
    contact_person VARCHAR(255),                        -- Primary contact person
    email VARCHAR(255) UNIQUE NOT NULL,                 -- Organizer email address (unique)
    phone VARCHAR(20),                                  -- Organizer phone number
    website VARCHAR(255),                               -- Organization website
    specialization VARCHAR(100),                        -- Event specialization (corporate, weddings, conferences)
    rating DECIMAL(3, 2),                               -- Organizer rating (0-5)
    total_events INT DEFAULT 0                          -- Total number of events organized
);

-- EVENTS TABLE: Stores event details and schedules
-- Use this table for queries about: event names, event types, event dates, event times, venues, organizers, ticket prices, event capacity, event status
CREATE TABLE events (
    event_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each event
    event_name VARCHAR(255) NOT NULL,                   -- Event name/title
    event_type VARCHAR(50),                             -- Type (conference, seminar, workshop, concert, wedding)
    description TEXT,                                   -- Event description
    venue_id INT,                                       -- Venue where event is held
    organizer_id INT,                                   -- Organizer of the event
    event_date DATE,                                    -- Event date
    start_time TIME,                                    -- Event start time
    end_time TIME,                                      -- Event end time
    capacity INT,                                       -- Maximum attendees
    ticket_price DECIMAL(10, 2),                        -- Ticket price (0 for free events)
    status VARCHAR(20) DEFAULT 'scheduled',             -- Status (scheduled, ongoing, completed, cancelled)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     -- When event was created
    FOREIGN KEY (venue_id) REFERENCES venues(venue_id),
    FOREIGN KEY (organizer_id) REFERENCES event_organizers(organizer_id)
);

-- ATTENDEES TABLE: Stores event attendee information
-- Use this table for queries about: attendee names, attendee emails, companies, job titles, attendee registration dates
CREATE TABLE attendees (
    attendee_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each attendee
    first_name VARCHAR(100) NOT NULL,                   -- Attendee's first name
    last_name VARCHAR(100) NOT NULL,                    -- Attendee's last name
    email VARCHAR(255) UNIQUE NOT NULL,                 -- Attendee email address (unique)
    phone VARCHAR(20),                                  -- Attendee phone number
    company VARCHAR(255),                               -- Company/organization name
    job_title VARCHAR(100),                             -- Job title/position
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- When attendee registered
);

-- REGISTRATIONS TABLE: Links attendees to events with ticket information
-- Use this table for queries about: event registrations, ticket types, payment amounts, payment status, check-in status, registration dates
CREATE TABLE registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique identifier for each registration
    event_id INT,                                       -- Event being registered for
    attendee_id INT,                                    -- Attendee registering
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When registration was made
    ticket_type VARCHAR(50),                            -- Ticket type (general, VIP, early_bird)
    amount_paid DECIMAL(10, 2),                         -- Amount paid for ticket
    payment_status VARCHAR(20) DEFAULT 'pending',       -- Payment status (pending, paid, refunded)
    check_in_status VARCHAR(20) DEFAULT 'not_checked_in', -- Check-in status (not_checked_in, checked_in)
    check_in_time TIMESTAMP NULL,                       -- When attendee checked in
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id)
);

-- SPEAKERS TABLE: Stores event speaker information
-- Use this table for queries about: speaker names, speaker bios, speaker topics, speaker companies, speaker contact info
CREATE TABLE speakers (
    speaker_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each speaker
    first_name VARCHAR(100) NOT NULL,                   -- Speaker's first name
    last_name VARCHAR(100) NOT NULL,                    -- Speaker's last name
    email VARCHAR(255) UNIQUE NOT NULL,                 -- Speaker email address (unique)
    phone VARCHAR(20),                                  -- Speaker phone number
    bio TEXT,                                           -- Speaker biography
    expertise TEXT,                                     -- Areas of expertise/topics
    company VARCHAR(255),                               -- Company/organization
    title VARCHAR(100),                                 -- Professional title
    photo_url VARCHAR(500)                              -- URL to speaker photo
);

-- EVENT_SPEAKERS TABLE: Links speakers to events with session details
-- Use this table for queries about: event speakers, session titles, session times, speaking fees, speaker schedules
CREATE TABLE event_speakers (
    event_speaker_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique identifier for each event-speaker link
    event_id INT,                                       -- Event where speaker is presenting
    speaker_id INT,                                     -- Speaker presenting at event
    session_title VARCHAR(255),                         -- Title of speaker's session/presentation
    session_time TIME,                                  -- Time of speaker's session
    session_duration INT,                               -- Session duration in minutes
    speaking_fee DECIMAL(10, 2),                        -- Fee paid to speaker
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (speaker_id) REFERENCES speakers(speaker_id)
);

-- SPONSORS TABLE: Stores event sponsor information
-- Use this table for queries about: sponsor names, sponsorship levels, sponsorship amounts, sponsor benefits, sponsor logos
CREATE TABLE sponsors (
    sponsor_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each sponsor
    company_name VARCHAR(255) NOT NULL,                 -- Sponsor company name
    contact_person VARCHAR(255),                        -- Primary contact person
    email VARCHAR(255),                                 -- Sponsor email address
    phone VARCHAR(20),                                  -- Sponsor phone number
    website VARCHAR(255),                               -- Sponsor website URL
    industry VARCHAR(100)                               -- Sponsor industry (technology, finance, etc.)
);

-- EVENT_SPONSORS TABLE: Links sponsors to events with sponsorship details
-- Use this table for queries about: event sponsorships, sponsorship levels, sponsorship amounts, sponsor benefits
CREATE TABLE event_sponsors (
    event_sponsor_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique identifier for each event-sponsor link
    event_id INT,                                       -- Event being sponsored
    sponsor_id INT,                                     -- Sponsor providing sponsorship
    sponsorship_level VARCHAR(50),                      -- Sponsorship tier (platinum, gold, silver, bronze)
    sponsorship_amount DECIMAL(10, 2),                  -- Sponsorship amount paid
    benefits TEXT,                                      -- Sponsorship benefits (booth space, logo placement, etc.)
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (sponsor_id) REFERENCES sponsors(sponsor_id)
);

-- FEEDBACK TABLE: Stores attendee feedback and event ratings
-- Use this table for queries about: event feedback, ratings, recommendations, attendee satisfaction, feedback comments
CREATE TABLE feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each feedback entry
    event_id INT,                                       -- Event being reviewed
    attendee_id INT,                                    -- Attendee providing feedback
    rating INT CHECK (rating >= 1 AND rating <= 5),     -- Event rating (1-5 stars)
    comments TEXT,                                      -- Feedback comments/text
    would_recommend BOOLEAN,                            -- Whether attendee would recommend event
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,   -- When feedback was submitted
    FOREIGN KEY (event_id) REFERENCES events(event_id),
    FOREIGN KEY (attendee_id) REFERENCES attendees(attendee_id)
);











CREATE INDEX idx_events_date ON events(event_date);
CREATE INDEX idx_events_venue ON events(venue_id);
CREATE INDEX idx_registrations_event ON registrations(event_id);
CREATE INDEX idx_registrations_attendee ON registrations(attendee_id);
CREATE INDEX idx_event_speakers_event ON event_speakers(event_id);
CREATE INDEX idx_event_sponsors_event ON event_sponsors(event_id);
