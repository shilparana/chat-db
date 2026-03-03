-- CUSTOMERS TABLE: Stores customer account information and contact details
-- Use this table for queries about: customer names, emails, addresses, registration dates, loyalty points, active customers
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,              -- Unique identifier for each customer
    first_name VARCHAR(100) NOT NULL,            -- Customer's first name
    last_name VARCHAR(100) NOT NULL,             -- Customer's last name
    email VARCHAR(255) UNIQUE NOT NULL,          -- Customer's email address (unique)
    phone VARCHAR(20),                           -- Customer's phone number
    address TEXT,                                -- Customer's street address
    city VARCHAR(100),                           -- Customer's city
    state VARCHAR(50),                           -- Customer's state/province
    country VARCHAR(100),                        -- Customer's country
    postal_code VARCHAR(20),                     -- Customer's postal/ZIP code
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When customer registered
    last_login TIMESTAMP,                        -- Last login timestamp
    is_active BOOLEAN DEFAULT TRUE,              -- Whether customer account is active
    loyalty_points INTEGER DEFAULT 0             -- Customer's loyalty reward points
);

-- CATEGORIES TABLE: Stores product categories and hierarchical organization
-- Use this table for queries about: product categories, category names, parent categories, category structure
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,              -- Unique identifier for each category
    category_name VARCHAR(100) NOT NULL,         -- Name of the category
    parent_category_id INTEGER REFERENCES categories(category_id), -- Parent category for hierarchical structure
    description TEXT,                            -- Category description
    is_active BOOLEAN DEFAULT TRUE               -- Whether category is currently active
);

-- PRODUCTS TABLE: Stores product catalog with pricing and inventory information
-- Use this table for queries about: product names, prices, stock quantities, categories, brands, SKUs, product descriptions
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,               -- Unique identifier for each product
    product_name VARCHAR(255) NOT NULL,          -- Product name/title
    sku VARCHAR(100) UNIQUE NOT NULL,            -- Stock Keeping Unit (unique product code)
    category_id INTEGER REFERENCES categories(category_id), -- Product category
    description TEXT,                            -- Detailed product description
    price DECIMAL(10, 2) NOT NULL,               -- Selling price
    cost_price DECIMAL(10, 2),                   -- Cost/wholesale price
    stock_quantity INTEGER DEFAULT 0,            -- Current inventory quantity
    weight DECIMAL(8, 2),                        -- Product weight
    dimensions VARCHAR(100),                     -- Product dimensions (L x W x H)
    brand VARCHAR(100),                          -- Product brand name
    manufacturer VARCHAR(100),                   -- Product manufacturer
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When product was added
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Last update timestamp
    is_active BOOLEAN DEFAULT TRUE               -- Whether product is active/available
);

-- ORDERS TABLE: Stores customer purchase orders and transaction details
-- Use this table for queries about: order totals, order dates, order status, payment methods, shipping information, customer orders
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,                 -- Unique identifier for each order
    customer_id INTEGER REFERENCES customers(customer_id), -- Customer who placed the order
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When order was placed
    total_amount DECIMAL(12, 2) NOT NULL,        -- Total order amount
    tax_amount DECIMAL(10, 2),                   -- Tax amount
    shipping_amount DECIMAL(10, 2),              -- Shipping/delivery cost
    discount_amount DECIMAL(10, 2),              -- Discount applied
    status VARCHAR(50) DEFAULT 'pending',        -- Order status (pending, processing, shipped, delivered, cancelled)
    payment_method VARCHAR(50),                  -- Payment method used (credit_card, paypal, etc.)
    payment_status VARCHAR(50),                  -- Payment status (paid, pending, refunded)
    shipping_address TEXT,                       -- Delivery address
    billing_address TEXT,                        -- Billing address
    tracking_number VARCHAR(100),                -- Shipment tracking number
    notes TEXT                                   -- Additional order notes
);

-- ORDER_ITEMS TABLE: Stores individual line items for each order
-- Use this table for queries about: products in orders, quantities ordered, item prices, order details
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,            -- Unique identifier for each order item
    order_id INTEGER REFERENCES orders(order_id), -- Order this item belongs to
    product_id INTEGER REFERENCES products(product_id), -- Product ordered
    quantity INTEGER NOT NULL,                   -- Quantity ordered
    unit_price DECIMAL(10, 2) NOT NULL,          -- Price per unit at time of order
    discount DECIMAL(10, 2) DEFAULT 0,           -- Discount applied to this item
    subtotal DECIMAL(10, 2) NOT NULL             -- Line item subtotal (quantity * unit_price - discount)
);

-- REVIEWS TABLE: Stores customer product reviews and ratings
-- Use this table for queries about: product ratings, customer reviews, review dates, verified purchases
CREATE TABLE reviews (
    review_id SERIAL PRIMARY KEY,                -- Unique identifier for each review
    product_id INTEGER REFERENCES products(product_id), -- Product being reviewed
    customer_id INTEGER REFERENCES customers(customer_id), -- Customer who wrote the review
    rating INTEGER CHECK (rating >= 1 AND rating <= 5), -- Star rating (1-5)
    title VARCHAR(255),                          -- Review title/headline
    comment TEXT,                                -- Review text/comments
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- When review was posted
    is_verified_purchase BOOLEAN DEFAULT FALSE,  -- Whether reviewer purchased the product
    helpful_count INTEGER DEFAULT 0              -- Number of users who found review helpful
);

-- WISHLISTS TABLE: Stores customer wishlist items
-- Use this table for queries about: saved products, wishlist items, customer wishlists
CREATE TABLE wishlists (
    wishlist_id SERIAL PRIMARY KEY,              -- Unique identifier for each wishlist entry
    customer_id INTEGER REFERENCES customers(customer_id), -- Customer who saved the item
    product_id INTEGER REFERENCES products(product_id), -- Product saved to wishlist
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- When item was added to wishlist
);

-- SHOPPING_CARTS TABLE: Stores active shopping cart items
-- Use this table for queries about: cart contents, items in cart, cart quantities
CREATE TABLE shopping_carts (
    cart_id SERIAL PRIMARY KEY,                  -- Unique identifier for each cart item
    customer_id INTEGER REFERENCES customers(customer_id), -- Customer who owns the cart
    product_id INTEGER REFERENCES products(product_id), -- Product in cart
    quantity INTEGER NOT NULL,                   -- Quantity of product in cart
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- When item was added to cart
);







CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_products_sku ON products(sku);
CREATE INDEX idx_products_category ON products(category_id);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_reviews_product ON reviews(product_id);
