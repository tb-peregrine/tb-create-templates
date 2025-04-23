# Real-time User Engagement Monitoring API

This project provides an API for monitoring user engagement metrics in real-time.

## Tinybird

### Overview

This Tinybird project is designed to capture, process, and analyze user events in real-time. It offers endpoints for monitoring user engagement, traffic patterns, session duration, and user retention, allowing you to build dashboards and analytics tools with live data.

### Data Sources

#### user_events

This data source captures user engagement events with detailed information about user interactions, sessions, and device information.

**How to ingest data:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
        "event_id": "ev_12345",
        "user_id": "usr_abc123",
        "event_type": "page_view",
        "timestamp": "2023-06-15 14:30:00",
        "session_id": "sess_xyz789",
        "page": "/products",
        "duration": 45,
        "device_type": "mobile",
        "country": "US",
        "os": "iOS",
        "browser": "Safari"
     }'
```

### Endpoints

#### event_breakdown

Provides a breakdown of events by type within a specified time range, with optional filtering by user ID or country.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_breakdown.json?time_range=1%20hour&token=$TB_ADMIN_TOKEN"
```

Optional parameters:
- `time_range`: Time window for analysis (default: '1 hour')
- `user_id`: Filter by specific user
- `country`: Filter by specific country

#### realtime_traffic

Shows real-time page traffic with counts of page views.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/realtime_traffic.json?time_window=5%20minute&limit=10&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `time_window`: Time window for traffic analysis (default: '5 minute')
- `limit`: Number of pages to return (default: 10)

#### session_duration

Calculates average session duration over time intervals.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_duration.json?interval=1%20hour&time_range=1%20day&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `interval`: Aggregation interval (default: '1 hour')
- `time_range`: Analysis time window (default: '1 day')
- `device_type`: Optional filter for specific device types

#### active_users

Returns count of active users over a specified time period.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/active_users.json?time_range=1%20day&time_frame=hour&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `time_range`: Analysis time window (default: '1 day')
- `time_frame`: Time frame description (default: 'hour')
- `event_type`: Optional filter for specific event types
- `country`: Optional filter for specific countries

#### user_retention

Analyzes user retention by calculating returning users over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_retention.json?lookback_days=30%20day&token=$TB_ADMIN_TOKEN"
```

Parameters:
- `lookback_days`: How far back to analyze retention (default: '30 day')
