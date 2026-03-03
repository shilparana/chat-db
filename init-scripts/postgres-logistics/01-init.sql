-- WAREHOUSES TABLE: Stores warehouse locations and facility information
-- Use this table for queries about: warehouse names, locations, capacity, managers, warehouse addresses
CREATE TABLE warehouses (
    warehouse_id SERIAL PRIMARY KEY,                -- Unique identifier for each warehouse
    warehouse_name VARCHAR(255) NOT NULL,           -- Warehouse name
    address TEXT,                                   -- Street address
    city VARCHAR(100),                              -- City
    state VARCHAR(50),                              -- State/province
    country VARCHAR(100),                           -- Country
    postal_code VARCHAR(20),                        -- Postal/ZIP code
    capacity INTEGER,                               -- Storage capacity (units)
    manager_name VARCHAR(255),                      -- Warehouse manager name
    phone VARCHAR(20),                              -- Contact phone number
    is_active BOOLEAN DEFAULT TRUE                  -- Whether warehouse is operational
);

-- INVENTORY TABLE: Tracks product inventory levels across warehouses
-- Use this table for queries about: stock quantities, product locations, reorder levels, inventory counts
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,                -- Unique identifier for each inventory record
    warehouse_id INTEGER REFERENCES warehouses(warehouse_id), -- Warehouse storing this inventory
    product_code VARCHAR(100) NOT NULL,             -- Product code/SKU
    product_name VARCHAR(255) NOT NULL,             -- Product name
    quantity INTEGER DEFAULT 0,                     -- Current quantity in stock
    unit_of_measure VARCHAR(20),                    -- Unit (pieces, pallets, boxes, etc.)
    reorder_level INTEGER,                          -- Minimum quantity before reordering
    location_code VARCHAR(50),                      -- Specific location within warehouse
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- Last inventory update time
);

-- SHIPMENTS TABLE: Stores shipment tracking and delivery information
-- Use this table for queries about: tracking numbers, shipment status, delivery dates, shipping costs, carriers
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,                 -- Unique identifier for each shipment
    tracking_number VARCHAR(100) UNIQUE NOT NULL,   -- Unique tracking number
    origin_warehouse_id INTEGER REFERENCES warehouses(warehouse_id), -- Origin warehouse
    destination_address TEXT,                       -- Delivery street address
    destination_city VARCHAR(100),                  -- Delivery city
    destination_state VARCHAR(50),                  -- Delivery state/province
    destination_country VARCHAR(100),               -- Delivery country
    destination_postal_code VARCHAR(20),            -- Delivery postal/ZIP code
    shipment_date TIMESTAMP,                        -- When shipment was sent
    estimated_delivery TIMESTAMP,                   -- Estimated delivery date/time
    actual_delivery TIMESTAMP,                      -- Actual delivery date/time
    status VARCHAR(50) DEFAULT 'pending',           -- Status (pending, in_transit, delivered, cancelled)
    carrier VARCHAR(100),                           -- Shipping carrier name
    shipping_cost DECIMAL(10, 2),                   -- Cost of shipping
    weight DECIMAL(10, 2),                          -- Package weight
    dimensions VARCHAR(100)                         -- Package dimensions (L x W x H)
);

-- SHIPMENT_ITEMS TABLE: Stores individual items in each shipment
-- Use this table for queries about: items shipped, quantities, item condition, shipment contents
CREATE TABLE shipment_items (
    item_id SERIAL PRIMARY KEY,                     -- Unique identifier for each shipment item
    shipment_id INTEGER REFERENCES shipments(shipment_id), -- Shipment this item belongs to
    inventory_id INTEGER REFERENCES inventory(inventory_id), -- Inventory item being shipped
    quantity INTEGER NOT NULL,                      -- Quantity of this item in shipment
    condition VARCHAR(50) DEFAULT 'good'            -- Item condition (good, damaged, fragile)
);

-- VEHICLES TABLE: Stores delivery vehicle information and status
-- Use this table for queries about: vehicle types, vehicle capacity, vehicle status, maintenance schedules
CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,                  -- Unique identifier for each vehicle
    vehicle_number VARCHAR(50) UNIQUE NOT NULL,     -- Vehicle identification number
    vehicle_type VARCHAR(50),                       -- Type (truck, van, trailer)
    make VARCHAR(100),                              -- Vehicle manufacturer
    model VARCHAR(100),                             -- Vehicle model
    year INTEGER,                                   -- Manufacturing year
    capacity_kg DECIMAL(10, 2),                     -- Load capacity in kilograms
    fuel_type VARCHAR(50),                          -- Fuel type (diesel, gasoline, electric)
    status VARCHAR(20) DEFAULT 'available',         -- Status (available, in_use, maintenance)
    last_maintenance DATE,                          -- Last maintenance date
    next_maintenance DATE                           -- Next scheduled maintenance date
);

-- DRIVERS TABLE: Stores driver information and performance metrics
-- Use this table for queries about: driver names, license numbers, driver ratings, hire dates, driver status
CREATE TABLE drivers (
    driver_id SERIAL PRIMARY KEY,                   -- Unique identifier for each driver
    first_name VARCHAR(100) NOT NULL,               -- Driver's first name
    last_name VARCHAR(100) NOT NULL,                -- Driver's last name
    license_number VARCHAR(50) UNIQUE NOT NULL,     -- Commercial driver's license number
    phone VARCHAR(20),                              -- Driver phone number
    email VARCHAR(255),                             -- Driver email address
    hire_date DATE,                                 -- Date driver was hired
    status VARCHAR(20) DEFAULT 'active',            -- Status (active, inactive, on_leave)
    rating DECIMAL(3, 2)                            -- Driver performance rating (0-5)
);

-- ROUTES TABLE: Stores delivery route information
-- Use this table for queries about: route names, distances, durations, toll costs, start/end locations
CREATE TABLE routes (
    route_id SERIAL PRIMARY KEY,                    -- Unique identifier for each route
    route_name VARCHAR(255),                        -- Route name/description
    start_location VARCHAR(255),                    -- Starting location
    end_location VARCHAR(255),                      -- Ending location
    distance_km DECIMAL(10, 2),                     -- Route distance in kilometers
    estimated_duration_hours DECIMAL(5, 2),         -- Estimated travel time in hours
    toll_cost DECIMAL(8, 2)                         -- Total toll costs for route
);

-- DELIVERIES TABLE: Stores delivery assignments and execution details
-- Use this table for queries about: delivery schedules, assigned drivers, vehicles, routes, delivery status
CREATE TABLE deliveries (
    delivery_id SERIAL PRIMARY KEY,                 -- Unique identifier for each delivery
    shipment_id INTEGER REFERENCES shipments(shipment_id), -- Shipment being delivered
    vehicle_id INTEGER REFERENCES vehicles(vehicle_id), -- Vehicle assigned to delivery
    driver_id INTEGER REFERENCES drivers(driver_id), -- Driver assigned to delivery
    route_id INTEGER REFERENCES routes(route_id),   -- Route being followed
    departure_time TIMESTAMP,                       -- When delivery departed
    arrival_time TIMESTAMP,                         -- When delivery arrived
    status VARCHAR(50) DEFAULT 'scheduled',         -- Status (scheduled, in_progress, completed, failed)
    notes TEXT                                      -- Delivery notes or issues
);









CREATE INDEX idx_inventory_warehouse ON inventory(warehouse_id);
CREATE INDEX idx_inventory_product ON inventory(product_code);
CREATE INDEX idx_shipments_tracking ON shipments(tracking_number);
CREATE INDEX idx_shipments_status ON shipments(status);
CREATE INDEX idx_deliveries_shipment ON deliveries(shipment_id);
CREATE INDEX idx_deliveries_driver ON deliveries(driver_id);
