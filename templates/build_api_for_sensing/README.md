# IoT Sensor Data Analytics API

## Tinybird

### Overview
This Tinybird project provides an API for IoT sensor data analytics. It ingests, processes, and analyzes data from various sensors, allowing users to monitor sensor readings, detect anomalies, and generate statistics over specified time periods.

### Data Sources

#### sensor_data
Raw IoT sensor data ingested from devices with fields for device ID, sensor type, readings, battery levels, and location information.

**Example data ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=sensor_data" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "device_id": "device_123",
           "sensor_type": "temperature",
           "reading": 25.5,
           "reading_unit": "celsius",
           "battery_level": 0.87,
           "location": "building_a",
           "timestamp": "2023-07-12 14:30:00"
         }'
```

### Endpoints

#### latest_readings
Retrieves the most recent sensor readings with optional filtering by device ID, sensor type, or location.

**Example usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/latest_readings.json?token=$TB_ADMIN_TOKEN&device_id=device_123&hours_back=12"
```

**Parameters:**
- `device_id` (optional): Filter by specific device ID
- `sensor_type` (optional): Filter by sensor type (e.g., temperature, humidity)
- `location` (optional): Filter by location
- `hours_back` (optional, default 24): Only show readings from the last X hours
- `limit` (optional, default 100): Maximum number of readings to return

#### anomaly_detection
Identifies abnormal sensor readings by calculating deviation from historical averages.

**Example usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/anomaly_detection.json?token=$TB_ADMIN_TOKEN&threshold=4.0&baseline_days=14"
```

**Parameters:**
- `baseline_days` (optional, default 30): Number of days to use for baseline statistics
- `hours_back` (optional, default 24): Only analyze readings from the last X hours
- `threshold` (optional, default 3.0): Minimum standard deviation threshold to consider a reading anomalous
- `limit` (optional, default 100): Maximum number of anomalies to return

#### sensor_stats
Provides aggregated statistics for sensor readings over a specified time period.

**Example usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/sensor_stats.json?token=$TB_ADMIN_TOKEN&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

**Parameters:**
- `device_id` (optional): Filter by specific device ID
- `sensor_type` (optional): Filter by sensor type
- `location` (optional): Filter by location
- `start_date` (optional, default 7 days ago): Start of time period (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional, default now): End of time period (format: YYYY-MM-DD HH:MM:SS)
