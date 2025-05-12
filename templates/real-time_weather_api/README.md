
# Weather Pattern API

This project provides a real-time API for processing and analyzing weather measurement data from various stations around the world.

## Tinybird

### Overview

This Tinybird project is designed to ingest, process, and serve real-time weather data from multiple weather stations. It enables users to query current weather conditions, analyze historical weather patterns, and detect anomalies in weather measurements, all through an easy-to-use API.

### Data Sources

#### weather_measurements

This datasource stores raw weather measurements collected from various stations. Each record includes temperature, humidity, pressure, wind data, precipitation, location information, and a timestamp.

**Ingesting data example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=weather_measurements" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "station_id": "WS001",
    "location": "New York City",
    "latitude": 40.7128,
    "longitude": -74.0060,
    "temperature": 22.5,
    "humidity": 65.3,
    "pressure": 1013.2,
    "wind_speed": 5.2,
    "wind_direction": 180.0,
    "precipitation": 0.0,
    "timestamp": "2023-06-15 14:30:00",
    "country": "USA",
    "region": "Northeast"
  }'
```

### Endpoints

#### current_weather

This endpoint retrieves the most recent weather data for a specified location, region, or country.

**Example usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/current_weather.json?token=$TB_ADMIN_TOKEN&location=London&limit=10"
```

**Parameters:**
- `location` (optional): Filter by specific location
- `region` (optional): Filter by region
- `country` (optional): Filter by country
- `limit` (optional, default: 100): Maximum number of records to return

#### weather_stats

This endpoint provides aggregated weather statistics for a specific time period and region, including average, minimum, and maximum temperature, average humidity, pressure, wind speed, and total precipitation.

**Example usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/weather_stats.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&region=Northeast"
```

**Parameters:**
- `start_date` (optional, default: 2023-01-01 00:00:00): Start date for the analysis in YYYY-MM-DD HH:MM:SS format
- `end_date` (optional, default: current time): End date for the analysis in YYYY-MM-DD HH:MM:SS format
- `region` (optional): Filter by region
- `country` (optional): Filter by country

#### weather_anomalies

This endpoint detects weather anomalies based on configurable thresholds for temperature, humidity, and wind speed.

**Example usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/weather_anomalies.json?token=$TB_ADMIN_TOKEN&max_temperature=35.0&min_humidity=10.0&max_wind_speed=25.0"
```

**Parameters:**
- `min_temperature` (optional, default: 0.0): Minimum temperature threshold
- `max_temperature` (optional, default: 30.0): Maximum temperature threshold
- `min_humidity` (optional, default: 20.0): Minimum humidity threshold
- `max_humidity` (optional, default: 80.0): Maximum humidity threshold
- `max_wind_speed` (optional, default: 20.0): Maximum wind speed threshold
- `start_date` (optional, default: 2023-01-01 00:00:00): Start date in YYYY-MM-DD HH:MM:SS format
- `end_date` (optional, default: current time): End date in YYYY-MM-DD HH:MM:SS format
- `limit` (optional, default: 100): Maximum number of records to return
