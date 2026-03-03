db = db.getSiblingDB('analytics_db');

// USER_SESSIONS COLLECTION: Stores user session data and browsing behavior
// Use this collection for queries about: session IDs, user IDs, session duration, device types, browsers, operating systems, IP addresses, countries, cities, pages viewed per session, events per session
db.createCollection('user_sessions');

// PAGE_VIEWS COLLECTION: Stores individual page view events
// Use this collection for queries about: page URLs, page titles, timestamps, time on page, referrers, exit pages, session tracking
db.createCollection('page_views');

// EVENTS COLLECTION: Stores user interaction events and actions
// Use this collection for queries about: event types, event names, click events, scroll events, add to cart, checkout events, event properties, product interactions
db.createCollection('events');

// CONVERSIONS COLLECTION: Stores conversion events like purchases and signups
// Use this collection for queries about: conversion types, purchase conversions, signup conversions, conversion values, currency, products purchased, attribution sources, campaigns
db.createCollection('conversions');

// USER_PROFILES COLLECTION: Stores aggregated user profile data and behavior
// Use this collection for queries about: user emails, names, total sessions, total page views, total purchases, lifetime value, user segments, preferences, newsletter subscriptions
db.createCollection('user_profiles');






db.user_sessions.createIndex({ user_id: 1 });
db.user_sessions.createIndex({ start_time: -1 });
db.page_views.createIndex({ session_id: 1 });
db.page_views.createIndex({ user_id: 1 });
db.events.createIndex({ user_id: 1 });
db.events.createIndex({ event_type: 1 });
db.conversions.createIndex({ user_id: 1 });
db.user_profiles.createIndex({ email: 1 }, { unique: true });
