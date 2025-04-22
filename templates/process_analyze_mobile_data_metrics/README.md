
# Mobile App Analytics API

## Tinybird

### Overview
This Tinybird project provides a comprehensive analytics API for mobile applications, allowing you to track user behavior, analyze engagement metrics, and monitor app performance. The API processes mobile app usage events and provides insights on user retention, screen navigation, version adoption, and more.

### Data Sources

#### app_events
This data source stores user interactions with the mobile app, tracking various events and user activities.

**Ingestion Example:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=app_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "e123456",
       "user_id": "u789012",
       "event_type": "screen_view",
       "timestamp": "2023-10-15 14:30:45",
       "session_id": "s345678",
       "device_type": "mobile",
       "os_version": "iOS 16.2",
       "app_version": "3.2.1",
       "country": "US",
       "city": "San Francisco",
       "screen_name": "home",
       "properties": "{\"source\":\"notification\",\"duration\":45}"
     }'
```

### Endpoints

#### daily_active_users
Calculates daily active users (DAU) with optional filtering by date range, country, and device type.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/daily_active_users.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&country=US&device_type=mobile"
```

#### monthly_active_users
Calculates monthly active users (MAU) with optional filtering by date range, country, and device type.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/monthly_active_users.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&country=US&device_type=mobile"
```

#### session_metrics
Calculates session-based metrics such as session counts, unique users, and sessions per user.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&country=US&device_type=mobile"
```

#### app_version_adoption
Tracks app version adoption rates over time, showing the distribution of app versions used by users.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/app_version_adoption.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&country=US&device_type=mobile"
```

#### screen_flow_analysis
Analyzes user navigation patterns through app screens to identify common paths and drop-off points.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/screen_flow_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&country=US&device_type=mobile"
```

#### event_distribution
Analyzes distribution of events by type, with metrics on event counts and unique users.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_distribution.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&country=US&device_type=mobile"
```

#### user_retention
Calculates user retention rates over time, showing how many users return to the app after their first visit.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_retention.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01&end_date=2023-12-31&max_days=30&country=US&device_type=mobile"
```
