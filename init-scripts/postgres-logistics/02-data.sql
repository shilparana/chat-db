-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO warehouses (warehouse_name, address, city, state, country, postal_code, capacity, manager_name, phone) VALUES
('Central Distribution Center', '1000 Logistics Way', 'Memphis', 'TN', 'USA', '38101', 100000, 'Tom Harrison', '+1-555-4001'),
('East Coast Hub', '500 Harbor Blvd', 'Newark', 'NJ', 'USA', '07102', 75000, 'Sarah Mitchell', '+1-555-4002'),
('West Coast Facility', '2000 Pacific Ave', 'Los Angeles', 'CA', 'USA', '90001', 80000, 'Mike Chen', '+1-555-4003'),
('Midwest Warehouse', '750 Industrial Dr', 'Chicago', 'IL', 'USA', '60601', 65000, 'Lisa Rodriguez', '+1-555-4004'),
('Southern Distribution', '1200 Commerce St', 'Dallas', 'TX', 'USA', '75201', 70000, 'James Wilson', '+1-555-4005');
INSERT INTO inventory (warehouse_id, product_code, product_name, quantity, unit_of_measure, reorder_level, location_code) VALUES
(1, 'PROD-001', 'Electronic Components Set', 5000, 'units', 1000, 'A-01-05'),
(1, 'PROD-002', 'Industrial Tools Kit', 2500, 'units', 500, 'A-02-10'),
(2, 'PROD-003', 'Office Furniture Package', 1200, 'units', 200, 'B-01-03'),
(2, 'PROD-004', 'Computer Accessories', 8000, 'units', 1500, 'B-03-08'),
(3, 'PROD-005', 'Automotive Parts', 3500, 'units', 700, 'C-02-06'),
(3, 'PROD-006', 'Sporting Goods', 4200, 'units', 800, 'C-04-12'),
(4, 'PROD-007', 'Kitchen Appliances', 1800, 'units', 300, 'D-01-04'),
(4, 'PROD-008', 'Home Decor Items', 6500, 'units', 1200, 'D-05-09'),
(5, 'PROD-009', 'Medical Supplies', 9000, 'units', 2000, 'E-03-07'),
(5, 'PROD-010', 'Safety Equipment', 4500, 'units', 900, 'E-02-11');
INSERT INTO vehicles (vehicle_number, vehicle_type, make, model, year, capacity_kg, fuel_type, status, last_maintenance) VALUES
('TRK-001', 'truck', 'Freightliner', 'Cascadia', 2022, 18000.00, 'diesel', 'available', '2024-02-15'),
('TRK-002', 'truck', 'Volvo', 'VNL', 2023, 20000.00, 'diesel', 'in_use', '2024-01-20'),
('VAN-001', 'van', 'Mercedes', 'Sprinter', 2023, 3500.00, 'diesel', 'available', '2024-02-28'),
('VAN-002', 'van', 'Ford', 'Transit', 2022, 3000.00, 'gasoline', 'available', '2024-03-01'),
('TRK-003', 'truck', 'Kenworth', 'T680', 2021, 19000.00, 'diesel', 'maintenance', '2024-02-10'),
('VAN-003', 'van', 'Ram', 'ProMaster', 2023, 3200.00, 'diesel', 'in_use', '2024-02-25');
INSERT INTO drivers (first_name, last_name, license_number, phone, email, hire_date, status, rating) VALUES
('John', 'Driver', 'CDL-123456', '+1-555-5001', 'john.driver@logistics.com', '2020-01-15', 'active', 4.8),
('Maria', 'Rodriguez', 'CDL-234567', '+1-555-5002', 'maria.r@logistics.com', '2019-06-20', 'active', 4.9),
('David', 'Thompson', 'CDL-345678', '+1-555-5003', 'david.t@logistics.com', '2021-03-10', 'active', 4.7),
('Sarah', 'Johnson', 'CDL-456789', '+1-555-5004', 'sarah.j@logistics.com', '2022-08-05', 'active', 4.6),
('Michael', 'Brown', 'CDL-567890', '+1-555-5005', 'michael.b@logistics.com', '2020-11-12', 'active', 4.8),
('Emily', 'Davis', 'CDL-678901', '+1-555-5006', 'emily.d@logistics.com', '2021-09-18', 'active', 4.9);
INSERT INTO routes (route_name, start_location, end_location, distance_km, estimated_duration_hours, toll_cost) VALUES
('Memphis to Newark', 'Memphis, TN', 'Newark, NJ', 1450.00, 18.5, 45.00),
('Memphis to Los Angeles', 'Memphis, TN', 'Los Angeles, CA', 2850.00, 35.0, 75.00),
('Memphis to Chicago', 'Memphis, TN', 'Chicago, IL', 850.00, 10.5, 25.00),
('Newark to Boston', 'Newark, NJ', 'Boston, MA', 350.00, 4.5, 15.00),
('Los Angeles to San Francisco', 'Los Angeles, CA', 'San Francisco, CA', 615.00, 7.5, 20.00);
INSERT INTO shipments (tracking_number, origin_warehouse_id, destination_address, destination_city, destination_state, destination_country, destination_postal_code, shipment_date, estimated_delivery, status, carrier, shipping_cost, weight) VALUES
('SHIP-2024-001', 1, '123 Main St', 'New York', 'NY', 'USA', '10001', '2024-03-10 08:00:00', '2024-03-12 17:00:00', 'in_transit', 'FastShip Express', 125.00, 250.00),
('SHIP-2024-002', 2, '456 Oak Ave', 'Boston', 'MA', 'USA', '02101', '2024-03-11 09:00:00', '2024-03-12 14:00:00', 'in_transit', 'QuickDeliver', 85.00, 180.00),
('SHIP-2024-003', 3, '789 Pine Rd', 'San Diego', 'CA', 'USA', '92101', '2024-03-12 10:00:00', '2024-03-13 16:00:00', 'pending', 'FastShip Express', 95.00, 200.00),
('SHIP-2024-004', 1, '321 Elm St', 'Miami', 'FL', 'USA', '33101', '2024-03-09 07:00:00', '2024-03-11 18:00:00', 'delivered', 'Express Logistics', 150.00, 320.00),
('SHIP-2024-005', 4, '654 Maple Dr', 'Seattle', 'WA', 'USA', '98101', '2024-03-13 11:00:00', '2024-03-15 15:00:00', 'pending', 'QuickDeliver', 175.00, 400.00);
INSERT INTO shipment_items (shipment_id, inventory_id, quantity) VALUES
(1, 1, 100),
(1, 2, 50),
(2, 3, 25),
(3, 5, 75),
(4, 7, 30),
(5, 9, 150);
INSERT INTO deliveries (shipment_id, vehicle_id, driver_id, route_id, departure_time, status) VALUES
(1, 2, 1, 1, '2024-03-10 08:30:00', 'in_progress'),
(2, 6, 4, 4, '2024-03-11 09:15:00', 'in_progress'),
(4, 1, 2, 1, '2024-03-09 07:20:00', 'completed');
