
# SaaS Usage Analytics API

A real-time analytics API built with Tinybird for tracking and analyzing user behavior in SaaS applications.

## Tinybird

### Overview

This project implements a real-time analytics system for SaaS applications. It tracks user events, analyzes session data, monitors feature usage patterns, and provides active user metrics to help SaaS providers understand user behavior and optimize their products.

### Data Sources

#### app_events

This datasource captures all user events from SaaS applications, including session information, event types, device details, and more.

**Sample data ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=app_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "ev_12345",
       "user_id": "usr_789",
       "session_id": "sess_456",
       "event_type": "click",
       "feature": "dashboard",
       "timestamp": "2023-06-15 14:30:45",
       "device_type": "desktop",
       "browser": "chrome",
       "os": "macos",
       "location": "us-west",
       "metadata": "{\"button_id\":\"export_data\",\"page\":\"analytics\"}"
     }'
```

### Endpoints

#### session_insights

Provides detailed insights on user sessions including duration and engagement metrics.

**Sample request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_insights.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

Parameters:
- `start_date`: DateTime (format: YYYY-MM-DD HH:MM:SS) - Start date for filtering sessions
- `end_date`: DateTime (format: YYYY-MM-DD HH:MM:SS) - End date for filtering sessions
- `user_id`: String (optional) - Filter sessions by specific user
- `limit`: Integer (default: 100) - Limit number of results

#### feature_usage

Analyzes feature usage patterns across the application, showing total events, unique users, and average usage per user.

**Sample request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage.json?token=$TB_ADMIN_TOKEN&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59&device_type=mobile"
```

Parameters:
- `start_date`: DateTime (format: YYYY-MM-DD HH:MM:SS) - Start date for feature usage analysis
- `end_date`: DateTime (format: YYYY-MM-DD HH:MM:SS) - End date for feature usage analysis
- `device_type`: String (optional) - Filter by device type

#### active_users

Provides active user counts over customizable time periods with various filtering options.

**Sample request:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/active_users.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&interval=1%20week&event_type=login"
```

Parameters:
- `start_date`: DateTime (format: YYYY-MM-DD HH:MM:SS) - Start date for active users analysis
- `end_date`: DateTime (format: YYYY-MM-DD HH:MM:SS) - End date for active users analysis
- `interval`: String (default: '1 day') - Time interval for grouping (e.g., '1 hour', '1 day', '1 week')
- `event_type`: String (optional) - Filter by event type
- `feature`: String (optional) - Filter by feature
