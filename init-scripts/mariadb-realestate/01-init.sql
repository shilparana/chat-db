-- PROPERTIES TABLE: Stores real estate property listings
-- Use this table for queries about: property types, listing types, prices, addresses, bedrooms, bathrooms, square feet, property status, features, parking
CREATE TABLE properties (
    property_id INT AUTO_INCREMENT PRIMARY KEY,         -- Unique identifier for each property
    property_type VARCHAR(50) NOT NULL,                 -- Type (house, apartment, condo, townhouse, land)
    listing_type VARCHAR(20) NOT NULL,                  -- Listing type (sale, rent, lease)
    address TEXT NOT NULL,                              -- Street address
    city VARCHAR(100),                                  -- City
    state VARCHAR(50),                                  -- State/province
    country VARCHAR(100),                               -- Country
    postal_code VARCHAR(20),                            -- Postal/ZIP code
    price DECIMAL(12, 2) NOT NULL,                      -- Listing price
    bedrooms INT,                                       -- Number of bedrooms
    bathrooms DECIMAL(3, 1),                            -- Number of bathrooms (allows half baths)
    square_feet INT,                                    -- Interior square footage
    lot_size INT,                                       -- Lot size in square feet
    year_built INT,                                     -- Year property was built
    description TEXT,                                   -- Property description
    status VARCHAR(20) DEFAULT 'available',             -- Status (available, pending, sold, rented)
    listed_date DATE,                                   -- Date property was listed
    sold_date DATE,                                     -- Date property was sold (NULL if not sold)
    features TEXT,                                      -- Property features (pool, garage, etc.)
    parking_spaces INT                                  -- Number of parking spaces
);

-- AGENTS TABLE: Stores real estate agent information
-- Use this table for queries about: agent names, license numbers, specializations, experience, total sales, sales volume, agent ratings, active agents
CREATE TABLE agents (
    agent_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each agent
    first_name VARCHAR(100) NOT NULL,                   -- Agent's first name
    last_name VARCHAR(100) NOT NULL,                    -- Agent's last name
    email VARCHAR(255) UNIQUE NOT NULL,                 -- Agent email address (unique)
    phone VARCHAR(20),                                  -- Agent phone number
    license_number VARCHAR(50) UNIQUE,                  -- Real estate license number (unique)
    specialization VARCHAR(100),                        -- Specialization (residential, commercial, luxury)
    years_experience INT,                               -- Years of experience
    total_sales INT DEFAULT 0,                          -- Total number of properties sold
    total_volume DECIMAL(15, 2) DEFAULT 0,              -- Total sales volume in dollars
    rating DECIMAL(3, 2),                               -- Agent rating (0-5)
    is_active BOOLEAN DEFAULT TRUE                      -- Whether agent is currently active
);

-- CLIENTS TABLE: Stores buyer/seller client information
-- Use this table for queries about: client names, client types, budgets, preferred locations, client requirements, registration dates
CREATE TABLE clients (
    client_id INT AUTO_INCREMENT PRIMARY KEY,           -- Unique identifier for each client
    first_name VARCHAR(100) NOT NULL,                   -- Client's first name
    last_name VARCHAR(100) NOT NULL,                    -- Client's last name
    email VARCHAR(255) UNIQUE NOT NULL,                 -- Client email address (unique)
    phone VARCHAR(20),                                  -- Client phone number
    client_type VARCHAR(20),                            -- Type (buyer, seller, both)
    budget_min DECIMAL(12, 2),                          -- Minimum budget
    budget_max DECIMAL(12, 2),                          -- Maximum budget
    preferred_locations TEXT,                           -- Preferred locations/neighborhoods
    requirements TEXT,                                  -- Specific requirements/preferences
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- When client registered
);

-- PROPERTY_LISTINGS TABLE: Links properties to agents with listing details
-- Use this table for queries about: listing prices, commission rates, listing dates, expiry dates, listing status, agent listings
CREATE TABLE property_listings (
    listing_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each listing
    property_id INT,                                    -- Property being listed
    agent_id INT,                                       -- Agent managing the listing
    listing_price DECIMAL(12, 2),                       -- Listed price
    commission_rate DECIMAL(5, 2),                      -- Commission percentage
    listing_date DATE,                                  -- Date property was listed
    expiry_date DATE,                                   -- Listing expiration date
    status VARCHAR(20) DEFAULT 'active',                -- Status (active, expired, sold)
    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- VIEWINGS TABLE: Stores property viewing appointments
-- Use this table for queries about: viewing dates, viewing status, scheduled viewings, client viewings, property showings
CREATE TABLE viewings (
    viewing_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique identifier for each viewing
    property_id INT,                                    -- Property being viewed
    client_id INT,                                      -- Client viewing the property
    agent_id INT,                                       -- Agent conducting the viewing
    viewing_date TIMESTAMP,                             -- Scheduled viewing date/time
    duration_minutes INT DEFAULT 30,                    -- Viewing duration in minutes
    status VARCHAR(20) DEFAULT 'scheduled',             -- Status (scheduled, completed, cancelled, no_show)
    feedback TEXT,                                      -- Client feedback after viewing
    interest_level VARCHAR(20),                         -- Interest level (low, medium, high)
    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- OFFERS TABLE: Stores purchase offers on properties
-- Use this table for queries about: offer amounts, offer dates, offer status, accepted offers, rejected offers, pending offers
CREATE TABLE offers (
    offer_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each offer
    property_id INT,                                    -- Property being offered on
    client_id INT,                                      -- Client making the offer
    agent_id INT,                                       -- Agent representing the client
    offer_amount DECIMAL(12, 2),                        -- Offer amount
    offer_date DATE,                                    -- Date offer was made
    contingencies TEXT,                                 -- Offer contingencies (financing, inspection, etc.),
    status VARCHAR(20) DEFAULT 'pending',               -- Offer status (pending, accepted, rejected, countered)
    response_date DATE,                                 -- Date seller responded to offer
    counter_offer_amount DECIMAL(12, 2),                -- Counter offer amount (if applicable)
    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- TRANSACTIONS TABLE: Stores completed property sales transactions
-- Use this table for queries about: sale prices, sale dates, commission amounts, transaction status, closing dates, closing costs
CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,      -- Unique identifier for each transaction
    property_id INT,                                    -- Property being sold
    buyer_id INT,                                       -- Buyer client
    seller_id INT,                                      -- Seller client
    listing_agent_id INT,                               -- Agent representing seller
    buying_agent_id INT,                                -- Agent representing buyer
    sale_price DECIMAL(12, 2),                          -- Final sale price
    sale_date DATE,                                     -- Date of sale
    commission_amount DECIMAL(10, 2),                   -- Total commission amount
    closing_costs DECIMAL(10, 2),                       -- Closing costs
    status VARCHAR(20) DEFAULT 'in_progress',           -- Transaction status (in_progress, completed, cancelled)
    FOREIGN KEY (property_id) REFERENCES properties(property_id),
    FOREIGN KEY (buyer_id) REFERENCES clients(client_id),
    FOREIGN KEY (seller_id) REFERENCES clients(client_id),
    FOREIGN KEY (listing_agent_id) REFERENCES agents(agent_id),
    FOREIGN KEY (buying_agent_id) REFERENCES agents(agent_id)
);

-- PROPERTY_IMAGES TABLE: Stores property photos and images
-- Use this table for queries about: property photos, image URLs, primary images, image types, upload dates
CREATE TABLE property_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,            -- Unique identifier for each image
    property_id INT,                                    -- Property this image belongs to
    image_url VARCHAR(500),                             -- URL to image file
    image_type VARCHAR(50),                             -- Image type (exterior, interior, kitchen, bathroom, etc.)
    is_primary BOOLEAN DEFAULT FALSE,                   -- Whether this is the primary/featured image
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,    -- When image was uploaded
    FOREIGN KEY (property_id) REFERENCES properties(property_id)
);








CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_status ON properties(status);
CREATE INDEX idx_properties_price ON properties(price);
CREATE INDEX idx_listings_agent ON property_listings(agent_id);
CREATE INDEX idx_viewings_property ON viewings(property_id);
CREATE INDEX idx_offers_property ON offers(property_id);
CREATE INDEX idx_transactions_property ON transactions(property_id);
