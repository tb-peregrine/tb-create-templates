
# Fitness App Analytics API

## Tinybird

### Overview
This project provides a real-time API for tracking and analyzing fitness app usage patterns. It allows you to collect user activity data and query insights about popular activities, app usage metrics, and individual user summaries.

### Data sources

#### app_events
Stores fitness app events and activities from users including workout data, app interactions, and device information.

**Sample data ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=app_events" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "event_id": "e123456",
    "user_id": "u789012",
    "event_type": "workout_completed",
    "timestamp": "2023-06-15 08:30:00",
    "app_version": "2.1.0",
    "device_type": "smartphone",
    "device_os": "iOS",
    "session_id": "sess_abcdef",
    "duration_seconds": 1800,
    "activity_type": "running",
    "calories_burned": 250,
    "distance_km": 5.2,
    "heart_rate": 142,
    "location_lat": 40.7128,
    "location_lon": -74.0060
  }'
```

### Endpoints

#### popular_activities
This endpoint provides insights into the most popular activities based on user engagement. It returns activity types ranked by user count along with average metrics.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_activities.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=5"
```

**Parameters:**
- `start_date` (optional): Filter activities from this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): Filter activities until this date (format: YYYY-MM-DD HH:MM:SS)
- `limit` (optional): Number of activities to return (default: 10)

#### app_usage_metrics
This endpoint provides daily app usage metrics over a specified time range with optional filtering by device OS and app version.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/app_usage_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59&device_os=iOS"
```

**Parameters:**
- `start_date`: Start date for analysis (format: YYYY-MM-DD HH:MM:SS, default: 2023-01-01 00:00:00)
- `end_date`: End date for analysis (format: YYYY-MM-DD HH:MM:SS, default: 2023-12-31 23:59:59)
- `device_os` (optional): Filter by device operating system
- `app_version` (optional): Filter by app version

#### user_activity_summary
This endpoint provides a summary of activities for a specific user over a specified time period.

**Sample request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity_summary.json?token=$TB_ADMIN_TOKEN&user_id=u789012&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

**Parameters:**
- `user_id`: User identifier (default: 12345)
- `start_date`: Start date for analysis (format: YYYY-MM-DD HH:MM:SS, default: 2023-01-01 00:00:00)
- `end_date`: End date for analysis (format: YYYY-MM-DD HH:MM:SS, default: 2023-12-31 23:59:59)
