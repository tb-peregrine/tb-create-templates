
# Ride-Sharing Analytics API

## Tinybird

### Overview
This project provides a real-time analytics API for a ride-sharing service. It tracks ride metrics, driver performance, and usage patterns to help optimize operations and improve customer experience.

### Data sources

#### Rides
Stores ride-sharing service data including ride details, driver information, and customer feedback.

Example of how to ingest data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=rides" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "ride_id": "r123456",
    "driver_id": "d789012",
    "user_id": "u345678",
    "pickup_time": "2023-05-15 14:30:00",
    "dropoff_time": "2023-05-15 15:00:00",
    "pickup_location": "Downtown",
    "dropoff_location": "Airport",
    "distance_km": 12.5,
    "duration_minutes": 30,
    "fare_amount": 25.75,
    "rating": 5,
    "status": "completed",
    "platform": "mobile",
    "city": "New York",
    "timestamp": "2023-05-15 14:30:00"
  }'
```

### Endpoints

#### Driver Performance
Track individual driver performance metrics with filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/driver_performance.json?token=$TB_ADMIN_TOKEN&driver_id=d789012&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&city=New%20York&limit=10"
```

#### Hourly Ride Trends
View ride trends aggregated by hour of day to identify peak hours.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/hourly_ride_trends.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&city=New%20York&platform=mobile"
```

#### Ride Statistics
Provides overall ride statistics with filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ride_statistics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&city=New%20York"
```
