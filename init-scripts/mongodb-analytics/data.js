// Sample data for database
// This file is loaded after schema creation

db.user_sessions.insertMany([
    {
        session_id: "sess_001",
        user_id: "user_12345",
        start_time: new Date("2024-03-15T10:00:00Z"),
        end_time: new Date("2024-03-15T10:45:00Z"),
        duration_seconds: 2700,
        device_type: "desktop",
        browser: "Chrome",
        os: "Windows 10",
        ip_address: "192.168.1.100",
        country: "USA",
        city: "New York",
        pages_viewed: 12,
        events_triggered: 8
    },
    {
        session_id: "sess_002",
        user_id: "user_67890",
        start_time: new Date("2024-03-15T11:30:00Z"),
        end_time: new Date("2024-03-15T12:15:00Z"),
        duration_seconds: 2700,
        device_type: "mobile",
        browser: "Safari",
        os: "iOS 17",
        ip_address: "192.168.1.101",
        country: "UK",
        city: "London",
        pages_viewed: 8,
        events_triggered: 5
    },
    {
        session_id: "sess_003",
        user_id: "user_11111",
        start_time: new Date("2024-03-15T14:00:00Z"),
        end_time: new Date("2024-03-15T14:30:00Z"),
        duration_seconds: 1800,
        device_type: "tablet",
        browser: "Firefox",
        os: "Android 13",
        ip_address: "192.168.1.102",
        country: "Canada",
        city: "Toronto",
        pages_viewed: 6,
        events_triggered: 4
    }
]);
db.page_views.insertMany([
    {
        page_view_id: "pv_001",
        session_id: "sess_001",
        user_id: "user_12345",
        page_url: "/products/laptop-pro",
        page_title: "Laptop Pro - Premium Computing",
        timestamp: new Date("2024-03-15T10:05:00Z"),
        time_on_page: 120,
        referrer: "https://google.com",
        exit_page: false
    },
    {
        page_view_id: "pv_002",
        session_id: "sess_001",
        user_id: "user_12345",
        page_url: "/cart",
        page_title: "Shopping Cart",
        timestamp: new Date("2024-03-15T10:10:00Z"),
        time_on_page: 180,
        referrer: "/products/laptop-pro",
        exit_page: false
    },
    {
        page_view_id: "pv_003",
        session_id: "sess_002",
        user_id: "user_67890",
        page_url: "/",
        page_title: "Home Page",
        timestamp: new Date("2024-03-15T11:30:00Z"),
        time_on_page: 90,
        referrer: "https://facebook.com",
        exit_page: false
    }
]);
db.events.insertMany([
    {
        event_id: "evt_001",
        session_id: "sess_001",
        user_id: "user_12345",
        event_type: "click",
        event_name: "add_to_cart",
        timestamp: new Date("2024-03-15T10:08:00Z"),
        properties: {
            product_id: "prod_001",
            product_name: "Laptop Pro",
            price: 1299.99,
            quantity: 1
        }
    },
    {
        event_id: "evt_002",
        session_id: "sess_001",
        user_id: "user_12345",
        event_type: "click",
        event_name: "checkout_started",
        timestamp: new Date("2024-03-15T10:12:00Z"),
        properties: {
            cart_value: 1299.99,
            items_count: 1
        }
    },
    {
        event_id: "evt_003",
        session_id: "sess_002",
        user_id: "user_67890",
        event_type: "scroll",
        event_name: "scroll_depth_75",
        timestamp: new Date("2024-03-15T11:35:00Z"),
        properties: {
            page: "/",
            depth_percentage: 75
        }
    }
]);
db.conversions.insertMany([
    {
        conversion_id: "conv_001",
        user_id: "user_12345",
        session_id: "sess_001",
        conversion_type: "purchase",
        timestamp: new Date("2024-03-15T10:15:00Z"),
        value: 1299.99,
        currency: "USD",
        products: [
            {
                product_id: "prod_001",
                product_name: "Laptop Pro",
                quantity: 1,
                price: 1299.99
            }
        ],
        attribution: {
            source: "google",
            medium: "cpc",
            campaign: "spring_sale"
        }
    },
    {
        conversion_id: "conv_002",
        user_id: "user_67890",
        session_id: "sess_002",
        conversion_type: "signup",
        timestamp: new Date("2024-03-15T11:45:00Z"),
        value: 0,
        currency: "USD",
        attribution: {
            source: "facebook",
            medium: "social",
            campaign: "brand_awareness"
        }
    }
]);
db.user_profiles.insertMany([
    {
        user_id: "user_12345",
        email: "john.doe@email.com",
        first_name: "John",
        last_name: "Doe",
        created_at: new Date("2024-01-15T00:00:00Z"),
        last_active: new Date("2024-03-15T10:45:00Z"),
        total_sessions: 45,
        total_page_views: 320,
        total_purchases: 8,
        lifetime_value: 5600.00,
        segments: ["high_value", "frequent_buyer"],
        preferences: {
            newsletter: true,
            notifications: true,
            categories: ["electronics", "computers"]
        }
    },
    {
        user_id: "user_67890",
        email: "jane.smith@email.com",
        first_name: "Jane",
        last_name: "Smith",
        created_at: new Date("2024-03-15T11:45:00Z"),
        last_active: new Date("2024-03-15T12:15:00Z"),
        total_sessions: 1,
        total_page_views: 8,
        total_purchases: 0,
        lifetime_value: 0,
        segments: ["new_user"],
        preferences: {
            newsletter: true,
            notifications: false
        }
    }
]);
