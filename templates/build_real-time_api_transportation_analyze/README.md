# Public Transportation Usage Analytics API

This project provides a real-time API for analyzing public transportation usage patterns, helping transportation authorities optimize routes, schedules, and vehicle allocation.

## Tinybird

### Overview
This Tinybird project provides a real-time API for analyzing public transportation usage data. It enables monitoring of current passenger loads, identification of popular routes, and analysis of usage trends over time to optimize public transportation services.

### Data Sources

#### transportation_events
Stores events related to public transportation usage, including information about vehicles, routes, passenger counts, and locations.

**Ingestion Example:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=transportation_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "evt_12345",
       "timestamp": "2023-06-15 08:30:00",
       "vehicle_id": "bus_789",
       "vehicle_type": "bus",
       "route_id": "route_42",
       "route_name": "Downtown Express",
       "passenger_count": 25,
       "stop_id": "stop_123",
       "location_lat": 40.7128,
       "location_lng": -74.0060
     }'
```

### Endpoints

#### popular_routes
Returns the most popular routes based on total passenger count within a specified date range.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_routes.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&vehicle_type=bus&limit=10"
```

**Parameters:**
- `start_date`: Start date for the analysis (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for the analysis (format: YYYY-MM-DD HH:MM:SS)
- `vehicle_type`: Optional filter for specific vehicle types
- `limit`: Maximum number of routes to return (default: 10)

#### current_usage_by_type
Provides current transportation usage statistics grouped by vehicle type.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_usage_by_type.json?token=$TB_ADMIN_TOKEN&timespan_minutes=30&vehicle_type=bus"
```

**Parameters:**
- `timespan_minutes`: Time window in minutes to consider as "current" (default: 30)
- `vehicle_type`: Optional filter for specific vehicle types

#### hourly_usage_trends
Returns hourly trends of transportation usage for analysis of peak times and patterns.

**Usage Example:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/hourly_usage_trends.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-01-31%2023:59:59&vehicle_type=subway"
```

**Parameters:**
- `start_date`: Start date for the analysis (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: End date for the analysis (format: YYYY-MM-DD HH:MM:SS)
- `vehicle_type`: Optional filter for specific vehicle types
