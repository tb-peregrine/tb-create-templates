# Real-time User Behavior Analytics API

## Tinybird

### Overview
This project provides a real-time analytics API for tracking and analyzing user behavior on websites or applications. It enables you to collect user events, analyze session data, view user timelines, and track activity metrics to better understand user engagement.

### Data Sources

#### user_events
This data source tracks user events such as page views, clicks, and other interactions. It stores detailed information about each user action including device information, location data, and custom properties.

Example of how to ingest data:
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "e123456",
       "user_id": "u789012",
       "session_id": "s345678",
       "event_type": "page_view",
       "page_url": "https://example.com/products",
       "referrer": "https://google.com",
       "device_type": "mobile",
       "browser": "Chrome",
       "country": "US",
       "city": "San Francisco",
       "properties": "{\"product_id\":\"p123\",\"category\":\"electronics\"}",
       "timestamp": "2023-06-15 14:32:45"
     }'
```

### Endpoints

#### user_session_stats
Provides session-level statistics for user behavior. This endpoint allows you to analyze how users engage during individual sessions, including duration, page views, and clicks.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_session_stats.json?token=$TB_ADMIN_TOKEN&user_id=u789012&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

Query parameters:
- `session_id` (optional): Filter by specific session
- `user_id` (optional): Filter by specific user
- `start_date` (optional): Start date in YYYY-MM-DD HH:MM:SS format
- `end_date` (optional): End date in YYYY-MM-DD HH:MM:SS format
- `limit` (optional): Maximum number of results to return (default: 100)

#### user_event_timeline
Provides a chronological timeline of events for a specific user. This endpoint is useful for understanding the sequence of actions a user takes during their website or app visit.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_event_timeline.json?token=$TB_ADMIN_TOKEN&user_id=u789012&event_type=page_view"
```

Query parameters:
- `user_id` (required): The ID of the user to view events for
- `session_id` (optional): Filter by specific session
- `start_date` (optional): Start date in YYYY-MM-DD HH:MM:SS format
- `end_date` (optional): End date in YYYY-MM-DD HH:MM:SS format
- `event_type` (optional): Filter by specific event type
- `limit` (optional): Maximum number of results to return (default: 100)

#### user_activity_metrics
Provides aggregated metrics on user activity over a time period. This endpoint delivers daily metrics that help identify trends in user engagement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-05-01%2000:00:00&end_date=2023-05-31%2023:59:59&country=US"
```

Query parameters:
- `start_date` (optional): Start date in YYYY-MM-DD HH:MM:SS format (default: 30 days ago)
- `end_date` (optional): End date in YYYY-MM-DD HH:MM:SS format (default: current time)
- `country` (optional): Filter by country
- `device_type` (optional): Filter by device type
