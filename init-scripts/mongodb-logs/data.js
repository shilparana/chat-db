// Sample data for database
// This file is loaded after schema creation

db.application_logs.insertMany([
    {
        log_id: "log_001",
        timestamp: new Date("2024-03-15T10:00:00Z"),
        level: "INFO",
        service: "api-gateway",
        message: "Request received: GET /api/products",
        request_id: "req_12345",
        user_id: "user_001",
        metadata: {
            method: "GET",
            path: "/api/products",
            status_code: 200,
            response_time_ms: 45
        }
    },
    {
        log_id: "log_002",
        timestamp: new Date("2024-03-15T10:01:00Z"),
        level: "INFO",
        service: "product-service",
        message: "Products retrieved successfully",
        request_id: "req_12345",
        metadata: {
            count: 150,
            cache_hit: true
        }
    },
    {
        log_id: "log_003",
        timestamp: new Date("2024-03-15T10:05:00Z"),
        level: "DEBUG",
        service: "order-service",
        message: "Processing order creation",
        request_id: "req_12346",
        user_id: "user_002",
        metadata: {
            order_id: "ord_001",
            items_count: 3,
            total_amount: 299.99
        }
    }
]);
db.error_logs.insertMany([
    {
        error_id: "err_001",
        timestamp: new Date("2024-03-15T10:15:00Z"),
        level: "ERROR",
        service: "payment-service",
        message: "Payment processing failed",
        error_type: "PaymentGatewayException",
        stack_trace: "at PaymentService.processPayment(payment.js:45)\nat OrderController.checkout(order.js:120)",
        request_id: "req_12347",
        user_id: "user_003",
        metadata: {
            payment_method: "credit_card",
            amount: 599.99,
            gateway_response: "insufficient_funds"
        }
    },
    {
        error_id: "err_002",
        timestamp: new Date("2024-03-15T10:30:00Z"),
        level: "ERROR",
        service: "inventory-service",
        message: "Database connection timeout",
        error_type: "DatabaseException",
        stack_trace: "at Database.connect(db.js:30)\nat InventoryService.checkStock(inventory.js:55)",
        request_id: "req_12348",
        metadata: {
            database: "inventory_db",
            timeout_ms: 5000
        }
    },
    {
        error_id: "err_003",
        timestamp: new Date("2024-03-15T11:00:00Z"),
        level: "WARN",
        service: "email-service",
        message: "Email delivery delayed",
        error_type: "EmailDeliveryWarning",
        request_id: "req_12349",
        metadata: {
            recipient: "customer@email.com",
            template: "order_confirmation",
            retry_count: 2
        }
    }
]);
db.audit_logs.insertMany([
    {
        audit_id: "audit_001",
        timestamp: new Date("2024-03-15T09:00:00Z"),
        action: "user_login",
        user_id: "user_001",
        user_email: "admin@company.com",
        ip_address: "192.168.1.100",
        user_agent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
        status: "success",
        metadata: {
            login_method: "password",
            mfa_enabled: true
        }
    },
    {
        audit_id: "audit_002",
        timestamp: new Date("2024-03-15T09:30:00Z"),
        action: "data_export",
        user_id: "user_001",
        user_email: "admin@company.com",
        ip_address: "192.168.1.100",
        resource_type: "customer_data",
        resource_id: "export_001",
        status: "success",
        metadata: {
            record_count: 1000,
            format: "csv"
        }
    },
    {
        audit_id: "audit_003",
        timestamp: new Date("2024-03-15T10:00:00Z"),
        action: "permission_change",
        user_id: "user_001",
        user_email: "admin@company.com",
        ip_address: "192.168.1.100",
        target_user_id: "user_005",
        status: "success",
        metadata: {
            previous_role: "user",
            new_role: "admin",
            changed_by: "user_001"
        }
    }
]);
db.performance_logs.insertMany([
    {
        perf_id: "perf_001",
        timestamp: new Date("2024-03-15T10:00:00Z"),
        service: "api-gateway",
        endpoint: "/api/products",
        method: "GET",
        response_time_ms: 45,
        cpu_usage_percent: 25.5,
        memory_usage_mb: 512,
        request_count: 150,
        error_count: 0
    },
    {
        perf_id: "perf_002",
        timestamp: new Date("2024-03-15T10:05:00Z"),
        service: "database",
        operation: "query",
        query_type: "SELECT",
        response_time_ms: 120,
        rows_affected: 500,
        metadata: {
            table: "products",
            index_used: true
        }
    },
    {
        perf_id: "perf_003",
        timestamp: new Date("2024-03-15T10:10:00Z"),
        service: "cache-service",
        operation: "get",
        response_time_ms: 5,
        hit_rate_percent: 85.5,
        cache_size_mb: 1024,
        eviction_count: 10
    }
]);
db.security_logs.insertMany([
    {
        security_id: "sec_001",
        timestamp: new Date("2024-03-15T08:00:00Z"),
        event_type: "failed_login_attempt",
        severity: "medium",
        ip_address: "203.0.113.45",
        user_email: "admin@company.com",
        attempt_count: 3,
        blocked: false,
        metadata: {
            reason: "invalid_password",
            user_agent: "Mozilla/5.0"
        }
    },
    {
        security_id: "sec_002",
        timestamp: new Date("2024-03-15T08:15:00Z"),
        event_type: "suspicious_activity",
        severity: "high",
        ip_address: "198.51.100.22",
        description: "Multiple failed API requests from same IP",
        blocked: true,
        metadata: {
            request_count: 100,
            time_window_seconds: 60,
            endpoints: ["/api/admin", "/api/users"]
        }
    },
    {
        security_id: "sec_003",
        timestamp: new Date("2024-03-15T09:00:00Z"),
        event_type: "unauthorized_access_attempt",
        severity: "critical",
        ip_address: "192.0.2.10",
        user_id: "user_010",
        resource: "/admin/settings",
        blocked: true,
        metadata: {
            required_permission: "admin",
            user_permission: "user"
        }
    }
]);
