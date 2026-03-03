// Sample data for database
// This file is loaded after schema creation

db.devices.insertMany([
    {
        device_id: "device_001",
        device_name: "Temperature Sensor - Warehouse A",
        device_type: "temperature_sensor",
        manufacturer: "IoT Sensors Inc",
        model: "TS-2000",
        serial_number: "TS2000-12345",
        location: {
            building: "Warehouse A",
            floor: 1,
            zone: "Storage Area 1",
            coordinates: {
                latitude: 37.7749,
                longitude: -122.4194
            }
        },
        status: "active",
        firmware_version: "2.1.5",
        last_seen: new Date("2024-03-15T12:00:00Z"),
        installed_date: new Date("2023-01-15T00:00:00Z"),
        battery_level: 85
    },
    {
        device_id: "device_002",
        device_name: "Humidity Sensor - Warehouse A",
        device_type: "humidity_sensor",
        manufacturer: "IoT Sensors Inc",
        model: "HS-3000",
        serial_number: "HS3000-67890",
        location: {
            building: "Warehouse A",
            floor: 1,
            zone: "Storage Area 1",
            coordinates: {
                latitude: 37.7749,
                longitude: -122.4194
            }
        },
        status: "active",
        firmware_version: "1.8.2",
        last_seen: new Date("2024-03-15T12:00:00Z"),
        installed_date: new Date("2023-01-15T00:00:00Z"),
        battery_level: 92
    },
    {
        device_id: "device_003",
        device_name: "Motion Detector - Office Floor 3",
        device_type: "motion_sensor",
        manufacturer: "Security Systems Ltd",
        model: "MD-500",
        serial_number: "MD500-11111",
        location: {
            building: "Office Building",
            floor: 3,
            zone: "Conference Room A",
            coordinates: {
                latitude: 37.7849,
                longitude: -122.4094
            }
        },
        status: "active",
        firmware_version: "3.0.1",
        last_seen: new Date("2024-03-15T12:00:00Z"),
        installed_date: new Date("2023-06-20T00:00:00Z"),
        battery_level: 78
    },
    {
        device_id: "device_004",
        device_name: "Smart Thermostat - Office Floor 2",
        device_type: "thermostat",
        manufacturer: "Climate Control Co",
        model: "ST-700",
        serial_number: "ST700-22222",
        location: {
            building: "Office Building",
            floor: 2,
            zone: "Open Office Area",
            coordinates: {
                latitude: 37.7849,
                longitude: -122.4094
            }
        },
        status: "active",
        firmware_version: "4.2.0",
        last_seen: new Date("2024-03-15T12:00:00Z"),
        installed_date: new Date("2023-03-10T00:00:00Z"),
        power_source: "AC"
    }
]);
db.sensor_readings.insertMany([
    {
        reading_id: "reading_001",
        device_id: "device_001",
        timestamp: new Date("2024-03-15T12:00:00Z"),
        sensor_type: "temperature",
        value: 22.5,
        unit: "celsius",
        quality: "good"
    },
    {
        reading_id: "reading_002",
        device_id: "device_001",
        timestamp: new Date("2024-03-15T12:05:00Z"),
        sensor_type: "temperature",
        value: 22.7,
        unit: "celsius",
        quality: "good"
    },
    {
        reading_id: "reading_003",
        device_id: "device_002",
        timestamp: new Date("2024-03-15T12:00:00Z"),
        sensor_type: "humidity",
        value: 45.2,
        unit: "percent",
        quality: "good"
    },
    {
        reading_id: "reading_004",
        device_id: "device_002",
        timestamp: new Date("2024-03-15T12:05:00Z"),
        sensor_type: "humidity",
        value: 45.8,
        unit: "percent",
        quality: "good"
    },
    {
        reading_id: "reading_005",
        device_id: "device_003",
        timestamp: new Date("2024-03-15T09:30:00Z"),
        sensor_type: "motion",
        value: 1,
        unit: "boolean",
        quality: "good",
        metadata: {
            motion_detected: true,
            confidence: 0.95
        }
    },
    {
        reading_id: "reading_006",
        device_id: "device_004",
        timestamp: new Date("2024-03-15T12:00:00Z"),
        sensor_type: "temperature",
        value: 21.0,
        unit: "celsius",
        quality: "good",
        metadata: {
            target_temperature: 21.0,
            heating_active: false,
            cooling_active: false
        }
    }
]);
db.device_events.insertMany([
    {
        event_id: "event_001",
        device_id: "device_001",
        event_type: "status_change",
        timestamp: new Date("2024-03-15T08:00:00Z"),
        description: "Device came online",
        previous_status: "offline",
        new_status: "active"
    },
    {
        event_id: "event_002",
        device_id: "device_003",
        event_type: "motion_detected",
        timestamp: new Date("2024-03-15T09:30:00Z"),
        description: "Motion detected in Conference Room A",
        metadata: {
            confidence: 0.95,
            duration_seconds: 120
        }
    },
    {
        event_id: "event_003",
        device_id: "device_004",
        event_type: "configuration_change",
        timestamp: new Date("2024-03-15T07:00:00Z"),
        description: "Target temperature updated",
        metadata: {
            previous_value: 20.0,
            new_value: 21.0,
            changed_by: "user_admin"
        }
    },
    {
        event_id: "event_004",
        device_id: "device_002",
        event_type: "battery_low",
        timestamp: new Date("2024-03-14T18:00:00Z"),
        description: "Battery level below 20%",
        metadata: {
            battery_level: 18,
            threshold: 20
        }
    }
]);
db.alerts.insertMany([
    {
        alert_id: "alert_001",
        device_id: "device_001",
        alert_type: "threshold_exceeded",
        severity: "warning",
        timestamp: new Date("2024-03-14T15:30:00Z"),
        description: "Temperature exceeded maximum threshold",
        triggered_by: {
            sensor_type: "temperature",
            value: 28.5,
            threshold: 25.0
        },
        status: "resolved",
        resolved_at: new Date("2024-03-14T16:00:00Z"),
        acknowledged_by: "user_admin"
    },
    {
        alert_id: "alert_002",
        device_id: "device_002",
        alert_type: "battery_low",
        severity: "medium",
        timestamp: new Date("2024-03-14T18:00:00Z"),
        description: "Device battery level is low",
        triggered_by: {
            battery_level: 18,
            threshold: 20
        },
        status: "active",
        acknowledged_by: "user_maintenance"
    },
    {
        alert_id: "alert_003",
        device_id: "device_003",
        alert_type: "offline",
        severity: "high",
        timestamp: new Date("2024-03-13T22:00:00Z"),
        description: "Device has gone offline",
        triggered_by: {
            last_seen: new Date("2024-03-13T21:55:00Z"),
            timeout_minutes: 5
        },
        status: "resolved",
        resolved_at: new Date("2024-03-14T08:00:00Z")
    }
]);
db.device_configurations.insertMany([
    {
        config_id: "config_001",
        device_id: "device_001",
        configuration: {
            reading_interval_seconds: 300,
            temperature_unit: "celsius",
            alert_thresholds: {
                min_temperature: 15.0,
                max_temperature: 25.0
            },
            reporting_enabled: true
        },
        updated_at: new Date("2024-03-01T00:00:00Z"),
        updated_by: "user_admin"
    },
    {
        config_id: "config_002",
        device_id: "device_002",
        configuration: {
            reading_interval_seconds: 300,
            humidity_unit: "percent",
            alert_thresholds: {
                min_humidity: 30.0,
                max_humidity: 60.0
            },
            reporting_enabled: true
        },
        updated_at: new Date("2024-03-01T00:00:00Z"),
        updated_by: "user_admin"
    },
    {
        config_id: "config_003",
        device_id: "device_003",
        configuration: {
            sensitivity: "high",
            detection_zone: "full_room",
            alert_on_motion: true,
            recording_enabled: false
        },
        updated_at: new Date("2024-02-15T00:00:00Z"),
        updated_by: "user_security"
    },
    {
        config_id: "config_004",
        device_id: "device_004",
        configuration: {
            target_temperature: 21.0,
            temperature_unit: "celsius",
            mode: "auto",
            schedule: {
                weekday: {
                    morning: 21.0,
                    day: 20.0,
                    evening: 21.5,
                    night: 19.0
                },
                weekend: {
                    all_day: 21.0
                }
            }
        },
        updated_at: new Date("2024-03-15T07:00:00Z"),
        updated_by: "user_admin"
    }
]);
