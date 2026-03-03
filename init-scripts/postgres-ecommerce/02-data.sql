-- Sample data for database
-- This file is loaded after schema creation

INSERT INTO categories (category_name, description) VALUES
('Electronics', 'Electronic devices and accessories'),
('Computers', 'Computers and computer accessories'),
('Mobile Phones', 'Smartphones and mobile accessories'),
('Clothing', 'Apparel and fashion'),
('Home & Kitchen', 'Home appliances and kitchen items'),
('Books', 'Physical and digital books'),
('Sports', 'Sports equipment and accessories'),
('Toys', 'Toys and games'),
('Beauty', 'Beauty and personal care products'),
('Automotive', 'Automotive parts and accessories');
INSERT INTO customers (first_name, last_name, email, phone, city, state, country, postal_code, loyalty_points) VALUES
('John', 'Doe', 'john.doe@email.com', '+1-555-0101', 'New York', 'NY', 'USA', '10001', 1250),
('Jane', 'Smith', 'jane.smith@email.com', '+1-555-0102', 'Los Angeles', 'CA', 'USA', '90001', 2300),
('Robert', 'Johnson', 'robert.j@email.com', '+1-555-0103', 'Chicago', 'IL', 'USA', '60601', 850),
('Emily', 'Williams', 'emily.w@email.com', '+1-555-0104', 'Houston', 'TX', 'USA', '77001', 1500),
('Michael', 'Brown', 'michael.b@email.com', '+1-555-0105', 'Phoenix', 'AZ', 'USA', '85001', 3200),
('Sarah', 'Davis', 'sarah.d@email.com', '+1-555-0106', 'Philadelphia', 'PA', 'USA', '19019', 950),
('David', 'Miller', 'david.m@email.com', '+1-555-0107', 'San Antonio', 'TX', 'USA', '78201', 1800),
('Lisa', 'Wilson', 'lisa.w@email.com', '+1-555-0108', 'San Diego', 'CA', 'USA', '92101', 2100),
('James', 'Moore', 'james.m@email.com', '+1-555-0109', 'Dallas', 'TX', 'USA', '75201', 1350),
('Jennifer', 'Taylor', 'jennifer.t@email.com', '+1-555-0110', 'San Jose', 'CA', 'USA', '95101', 2750);
INSERT INTO products (product_name, sku, category_id, description, price, cost_price, stock_quantity, brand) VALUES
('Laptop Pro 15', 'LAP-PRO-15', 2, 'High-performance laptop with 16GB RAM', 1299.99, 899.99, 45, 'TechBrand'),
('Smartphone X', 'PHONE-X-128', 3, 'Latest smartphone with 128GB storage', 899.99, 599.99, 120, 'PhoneCorp'),
('Wireless Headphones', 'HEAD-WL-BT', 1, 'Noise-cancelling Bluetooth headphones', 249.99, 149.99, 200, 'AudioTech'),
('Smart Watch Series 5', 'WATCH-S5-BLK', 1, 'Fitness tracking smartwatch', 399.99, 249.99, 85, 'WearTech'),
('4K Monitor 27"', 'MON-4K-27', 2, 'Ultra HD 4K monitor 27 inch', 449.99, 299.99, 60, 'DisplayCo'),
('Gaming Mouse RGB', 'MOUSE-GM-RGB', 2, 'RGB gaming mouse with 16000 DPI', 79.99, 39.99, 300, 'GameGear'),
('Mechanical Keyboard', 'KEY-MECH-RGB', 2, 'RGB mechanical gaming keyboard', 129.99, 69.99, 150, 'GameGear'),
('USB-C Hub 7-in-1', 'HUB-USBC-7', 2, '7-port USB-C hub adapter', 49.99, 24.99, 250, 'ConnectTech'),
('Portable SSD 1TB', 'SSD-PORT-1TB', 2, 'Portable external SSD 1TB', 159.99, 99.99, 180, 'StoragePro'),
('Wireless Charger', 'CHRG-WL-15W', 3, '15W fast wireless charger', 34.99, 19.99, 400, 'ChargeTech'),
('Phone Case Premium', 'CASE-PREM-BLK', 3, 'Premium protective phone case', 24.99, 9.99, 500, 'ProtectCo'),
('Screen Protector Glass', 'SCRN-GLASS-9H', 3, 'Tempered glass screen protector', 14.99, 4.99, 600, 'ProtectCo'),
('Bluetooth Speaker', 'SPKR-BT-360', 1, '360-degree Bluetooth speaker', 89.99, 49.99, 220, 'AudioTech'),
('Webcam HD 1080p', 'CAM-HD-1080', 2, 'Full HD 1080p webcam', 69.99, 39.99, 140, 'VisionTech'),
('Tablet 10" 64GB', 'TAB-10-64GB', 2, '10-inch tablet with 64GB storage', 329.99, 219.99, 95, 'TabletCo');
INSERT INTO orders (customer_id, total_amount, tax_amount, shipping_amount, status, payment_method, payment_status) VALUES
(1, 1549.98, 124.00, 0.00, 'delivered', 'credit_card', 'paid'),
(2, 899.99, 71.99, 15.00, 'delivered', 'paypal', 'paid'),
(3, 329.98, 26.40, 10.00, 'shipped', 'credit_card', 'paid'),
(4, 2199.96, 175.99, 0.00, 'processing', 'credit_card', 'paid'),
(5, 449.99, 35.99, 20.00, 'delivered', 'debit_card', 'paid'),
(1, 164.98, 13.20, 5.00, 'delivered', 'credit_card', 'paid'),
(6, 1299.99, 103.99, 0.00, 'cancelled', 'paypal', 'refunded'),
(7, 579.97, 46.40, 15.00, 'delivered', 'credit_card', 'paid'),
(8, 89.99, 7.19, 5.00, 'delivered', 'paypal', 'paid'),
(9, 1829.96, 146.40, 0.00, 'shipped', 'credit_card', 'paid');
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 1299.99, 1299.99),
(1, 3, 1, 249.99, 249.99),
(2, 2, 1, 899.99, 899.99),
(3, 4, 1, 399.99, 399.99),
(4, 1, 1, 1299.99, 1299.99),
(4, 5, 2, 449.99, 899.98),
(5, 5, 1, 449.99, 449.99),
(6, 10, 2, 34.99, 69.98),
(6, 11, 3, 24.99, 74.97),
(7, 1, 1, 1299.99, 1299.99);
INSERT INTO reviews (product_id, customer_id, rating, title, comment, is_verified_purchase) VALUES
(1, 1, 5, 'Excellent laptop!', 'Best laptop I have ever owned. Fast and reliable.', TRUE),
(2, 2, 4, 'Great phone', 'Good phone but battery could be better.', TRUE),
(3, 1, 5, 'Amazing sound quality', 'These headphones are worth every penny.', TRUE),
(4, 3, 4, 'Good smartwatch', 'Nice features but takes time to learn.', TRUE),
(5, 5, 5, 'Perfect monitor', 'Crystal clear display, highly recommend.', TRUE),
(1, 8, 5, 'Worth the price', 'Great performance for work and gaming.', FALSE),
(2, 9, 3, 'Decent phone', 'Good but overpriced in my opinion.', FALSE),
(3, 7, 5, 'Best headphones', 'Noise cancellation is incredible.', TRUE);
