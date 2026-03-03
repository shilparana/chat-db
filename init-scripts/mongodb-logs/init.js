db = db.getSiblingDB('logs_db');

// APPLICATION_LOGS COLLECTION: Stores general application logs and request tracking
// Use this collection for queries about: log levels, services, messages, request IDs, user IDs, API requests, response times, status codes, cache hits
db.createCollection('application_logs');

// ERROR_LOGS COLLECTION: Stores error logs and exceptions
// Use this collection for queries about: error types, error messages, stack traces, payment errors, database errors, service failures, error timestamps
db.createCollection('error_logs');

// AUDIT_LOGS COLLECTION: Stores audit trail of user actions and system changes
// Use this collection for queries about: user logins, data exports, permission changes, user actions, IP addresses, audit timestamps, resource access
db.createCollection('audit_logs');

// PERFORMANCE_LOGS COLLECTION: Stores performance metrics and monitoring data
// Use this collection for queries about: response times, CPU usage, memory usage, request counts, error counts, database queries, cache performance
db.createCollection('performance_logs');

// SECURITY_LOGS COLLECTION: Stores security events and threats
// Use this collection for queries about: failed login attempts, suspicious activity, unauthorized access, security severity levels, blocked IPs, security events
db.createCollection('security_logs');






db.application_logs.createIndex({ timestamp: -1 });
db.application_logs.createIndex({ service: 1 });
db.application_logs.createIndex({ level: 1 });
db.error_logs.createIndex({ timestamp: -1 });
db.error_logs.createIndex({ service: 1 });
db.error_logs.createIndex({ error_type: 1 });
db.audit_logs.createIndex({ timestamp: -1 });
db.audit_logs.createIndex({ user_id: 1 });
db.audit_logs.createIndex({ action: 1 });
db.performance_logs.createIndex({ timestamp: -1 });
db.performance_logs.createIndex({ service: 1 });
db.security_logs.createIndex({ timestamp: -1 });
db.security_logs.createIndex({ severity: 1 });
