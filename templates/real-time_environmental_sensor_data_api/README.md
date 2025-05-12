
# Environmental Sensor Monitoring API

This project provides a real-time API for monitoring environmental sensor data.

## Tinybird

### Overview

This Tinybird project implements a real-time API for processing and analyzing environmental sensor data. It collects readings from various sensors including temperature, humidity, and air quality parameters, and provides endpoints to query current conditions, analyze trends, and monitor sensor health.

### Data Sources

#### sensor_readings

Stores raw sensor data readings from environmental sensors including temperature, humidity, air quality, and location information.

**Sample data ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=sensor_readings" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "sensor_id": "sensor-001",
       "location": "building-a",
       "reading_type": "temperature",
       "reading_value": 22.5,
       "unit": "celsius",
       "timestamp": "2023-04-15 14:30:00.000",
       "battery_level": 85.2
     }'
```

### Endpoints

#### location_overview

Provides an overview of environmental conditions by location, including number of active sensors, sensors with low battery, and latest readings.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/location_overview.json?token=$TB_ADMIN_TOKEN&location=building-a&time_window_hours=24&battery_threshold=20.0"
```

Parameters:
- `location` (optional): Filter by specific location
- `time_window_hours` (optional, default: 24): Time window in hours for data analysis
- `battery_threshold` (optional, default: 20.0): Battery level threshold for low battery alerts

#### current_sensor_readings

Fetches the most recent readings for each sensor and reading type.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_sensor_readings.json?token=$TB_ADMIN_TOKEN&sensor_id=sensor-001&location=building-a&reading_type=temperature&time_window_hours=24&limit=1000"
```

Parameters:
- `sensor_id` (optional): Filter by specific sensor ID
- `location` (optional): Filter by specific location 
- `reading_type` (optional): Filter by reading type (temperature, humidity, etc.)
- `time_window_hours` (optional, default: 24): Time window in hours for data retrieval
- `limit` (optional, default: 1000): Maximum number of readings to return

#### sensor_stats

Provides statistical analysis of sensor readings for a specified time period.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sensor_stats.json?token=$TB_ADMIN_TOKEN&sensor_id=sensor-001&location=building-a&reading_type=temperature&time_window_hours=24"
```

Parameters:
- `sensor_id` (optional): Filter by specific sensor ID
- `location` (optional): Filter by specific location
- `reading_type` (optional): Filter by reading type (temperature, humidity, etc.)
- `time_window_hours` (optional, default: 24): Time window in hours for statistical analysis
