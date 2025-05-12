
# Smart City Traffic Analysis API

## Tinybird

### Overview
This project provides a real-time traffic analysis API for smart cities. It processes traffic events data from sensors across the city and delivers insights about traffic conditions, incident detection, and traffic patterns to help city officials make informed decisions.

### Data Sources

#### traffic_events
Stores raw traffic events data collected from various sensors across the city, including vehicle counts, speed data, congestion levels, and weather conditions.

**Sample Data Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=traffic_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "ev_12345",
       "device_id": "sensor_789",
       "timestamp": "2023-09-15 08:30:00",
       "location_lat": 40.7128,
       "location_lon": -74.0060,
       "location_name": "Main Street & 5th Avenue",
       "vehicle_count": 45,
       "average_speed_kph": 18.5,
       "congestion_level": 8,
       "weather_condition": "Rainy",
       "event_type": "Regular"
     }'
```

### Endpoints

#### current_traffic_conditions
Provides real-time traffic condition summaries, either for specific locations or across the entire city.

**Example Usage:**
```bash
# Get traffic conditions for all locations in the last 30 minutes
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_traffic_conditions.json?token=$TB_ADMIN_TOKEN"

# Get traffic conditions for a specific location in the last 60 minutes
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_traffic_conditions.json?token=$TB_ADMIN_TOKEN&time_window_minutes=60&location_filter=Main+Street+%26+5th+Avenue"
```

#### traffic_incident_detection
Detects potential traffic incidents based on congestion levels and reduced speeds, helping city officials respond quickly to emerging problems.

**Example Usage:**
```bash
# Get incidents with default parameters (last 60 minutes, congestion level >= 7, speed <= 20 kph)
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/traffic_incident_detection.json?token=$TB_ADMIN_TOKEN"

# Customize parameters for specific conditions
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/traffic_incident_detection.json?token=$TB_ADMIN_TOKEN&time_window_minutes=30&min_congestion_level=8&max_speed_kph=15.0&location_filter=Downtown+Bridge"
```

#### traffic_patterns_by_hour
Analyzes historical traffic patterns by hour, allowing officials to understand traffic trends and plan accordingly.

**Example Usage:**
```bash
# Get hourly patterns for the last 7 days (default)
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/traffic_patterns_by_hour.json?token=$TB_ADMIN_TOKEN"

# Get hourly patterns for a specific date range and location
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/traffic_patterns_by_hour.json?token=$TB_ADMIN_TOKEN&start_date=2023-09-01+00:00:00&end_date=2023-09-07+23:59:59&location_filter=Main+Street+%26+5th+Avenue"
```
