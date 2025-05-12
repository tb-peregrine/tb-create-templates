
# Real-Time Event Tracking API

A real-time analytics solution for tracking and analyzing user events from web and mobile applications.

## Tinybird

### Overview

This project provides a simple yet powerful event tracking API built on Tinybird. It allows you to ingest event data from various platforms and provides endpoints to query and analyze this data in real-time. The system is designed to track user behavior across sessions, analyze event patterns, and provide insights into user activity.

### Data Sources

#### events

This is the primary data source that stores raw events from web and mobile applications. It includes details about each event such as user information, device data, and custom properties.

**Ingestion Example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "event_id": "e123456",
      "event_type": "page_view",
      "user_id": "user_abc",
      "session_id": "sess_123",
      "timestamp": "2023-07-15 14:30:00",
      "platform": "web",
      "app_version": "1.2.3",
      "device_type": "desktop",
      "os": "Windows",
      "country": "US",
      "properties": "{\"page\":\"home\",\"referrer\":\"google\"}"
    }'
```

### Endpoints

#### get_events

This endpoint allows you to query the raw events with various filtering options. You can filter by event type, user ID, platform, and date range.

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_events.json?token=$TB_ADMIN_TOKEN&event_type=page_view&platform=web&start_date=2023-07-01%2000:00:00&end_date=2023-07-31%2023:59:59&limit=50"
```

#### user_activity

This endpoint provides detailed information about a specific user's activity, including session count, event count, first and last seen timestamps, and recently triggered event types.

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity.json?token=$TB_ADMIN_TOKEN&user_id=user_abc&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### event_stats

This endpoint provides aggregated statistics for events, including event counts, unique users, first and last seen timestamps, and session counts. You can filter by date range and platform.

**Usage Example:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_stats.json?token=$TB_ADMIN_TOKEN&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59&platform=mobile"
```

Note: For all endpoints, DateTime parameters must be formatted as YYYY-MM-DD HH:MM:SS, or the request will fail.
