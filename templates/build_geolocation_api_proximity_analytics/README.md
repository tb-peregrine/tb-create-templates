
# Geolocation Analytics API

A real-time API for processing and analyzing geolocation data, built with Tinybird.

## Tinybird

### Overview

This project provides a simple yet powerful API for processing geolocation data. It enables tracking user locations, retrieving user location history, analyzing location data over time, and finding nearby users based on coordinates. The API is designed for applications requiring real-time geolocation analytics.

### Data Sources

#### location_events

Stores location events with user IDs, coordinates, and timestamps. This is the main data source that captures all location data from users.

**Ingestion Example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=location_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "user_123",
       "latitude": 40.7128,
       "longitude": -74.0060,
       "accuracy": 15.5,
       "event_type": "check_in",
       "device_id": "device_abc",
       "timestamp": "2023-10-15 14:30:00"
     }'
```

### Endpoints

#### user_location_history

Retrieves the location history for a specific user within a defined time range.

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_location_history.json?token=$TB_ADMIN_TOKEN&user_id=user_123&start_time=2023-01-01%2000:00:00&end_time=2023-12-31%2023:59:59&limit=500"
```

#### location_analytics

Provides analytics on location events by aggregating data over different time periods (hour, day, week, month).

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/location_analytics.json?token=$TB_ADMIN_TOKEN&time_bucket=day&start_time=2023-01-01%2000:00:00&end_time=2023-12-31%2023:59:59&event_type=check_in"
```

#### nearby_users

Finds users within a specified radius of given coordinates.

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/nearby_users.json?token=$TB_ADMIN_TOKEN&target_lat=40.7128&target_lon=-74.0060&radius_km=2.5&start_time=2023-10-15%2000:00:00&end_time=2023-10-15%2023:59:59&limit=50"
```
