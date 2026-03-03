db = db.getSiblingDB('iot_db');

// DEVICES COLLECTION: Stores IoT device information and metadata
// Use this collection for queries about: device names, device types, manufacturers, models, serial numbers, device locations, device status, firmware versions, battery levels, temperature sensors, humidity sensors, motion sensors, thermostats
db.createCollection('devices');

// SENSOR_READINGS COLLECTION: Stores time-series sensor data from IoT devices
// Use this collection for queries about: sensor readings, temperature readings, humidity readings, motion detection, sensor values, timestamps, sensor types, reading quality
db.createCollection('sensor_readings');

// DEVICE_EVENTS COLLECTION: Stores device events and state changes
// Use this collection for queries about: device status changes, motion detected events, configuration changes, battery low events, device online/offline, event timestamps
db.createCollection('device_events');

// ALERTS COLLECTION: Stores alerts triggered by devices and sensors
// Use this collection for queries about: alert types, alert severity, threshold exceeded alerts, battery low alerts, offline alerts, alert status, resolved alerts
db.createCollection('alerts');

// DEVICE_CONFIGURATIONS COLLECTION: Stores device configuration settings
// Use this collection for queries about: device configurations, reading intervals, alert thresholds, temperature settings, humidity settings, device modes, schedules
db.createCollection('device_configurations');






db.devices.createIndex({ device_id: 1 }, { unique: true });
db.devices.createIndex({ device_type: 1 });
db.devices.createIndex({ status: 1 });
db.sensor_readings.createIndex({ device_id: 1, timestamp: -1 });
db.sensor_readings.createIndex({ timestamp: -1 });
db.device_events.createIndex({ device_id: 1, timestamp: -1 });
db.device_events.createIndex({ event_type: 1 });
db.alerts.createIndex({ device_id: 1 });
db.alerts.createIndex({ status: 1 });
db.alerts.createIndex({ severity: 1 });
db.device_configurations.createIndex({ device_id: 1 });
