# Tinybird Fitness Wearable API

## Tinybird

### Overview
This Tinybird project provides a simple API for processing and analyzing fitness wearable data. It ingests raw fitness metrics like steps, heart rate, and calories burned, and provides endpoints for retrieving daily summaries, recent activity, and heart rate analysis.

### Data Sources
#### fitness_data
This datasource stores raw fitness wearable data containing metrics like steps, heart rate, calories burned, distance, sleep minutes, and active minutes.

**How to ingest data:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=fitness_data" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "user_id": "user123",
      "device_id": "device456",
      "timestamp": "2023-03-15 14:30:00",
      "steps": 8542,
      "heart_rate": 72,
      "calories_burned": 325.5,
      "distance_meters": 6250.0,
      "sleep_minutes": 0,
      "active_minutes": 45
    }'
```

### Endpoints
#### user_daily_summary
Summarizes fitness metrics by user and day, providing totals for steps, calories, distance, sleep, and active minutes, plus average heart rate.

**How to use:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_daily_summary.json?token=$TB_ADMIN_TOKEN&user_id=user123&start_date=2023-01-01&end_date=2023-12-31"
```

#### recent_activity
Retrieves the most recent fitness data for a specific user, showing detailed metrics for each activity record.

**How to use:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recent_activity.json?token=$TB_ADMIN_TOKEN&user_id=user123&limit=100"
```

#### heart_rate_analysis
Provides heart rate statistics (minimum, maximum, average) for users by date, useful for monitoring cardiovascular health and exercise intensity.

**How to use:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/heart_rate_analysis.json?token=$TB_ADMIN_TOKEN&user_id=user123&start_date=2023-01-01&end_date=2023-12-31"
```
