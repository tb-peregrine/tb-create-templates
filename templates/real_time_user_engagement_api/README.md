# User Engagement Analytics API

A real-time analytics API for tracking and analyzing user engagement metrics for web and mobile applications.

## Tinybird

### Overview

This Tinybird project provides a real-time analytics platform for tracking and analyzing user engagement metrics. It enables developers to monitor session metrics, user activity, geographic distribution, and event-specific data with powerful filtering capabilities and time series support.

### Data Sources

#### user_events

This data source stores user event tracking data for measuring user engagement. It captures timestamps, user identifiers, event types, device information, session data, and geographic details.

To ingest data into the `user_events` data source:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-01-15 10:30:45",
       "user_id": "user_12345",
       "event_type": "page_view",
       "device": "desktop",
       "platform": "web",
       "session_id": "sess_67890",
       "duration": 120,
       "page": "/products",
       "country": "US",
       "region": "California",
       "city": "San Francisco"
     }'
```

### Endpoints

#### session_metrics

This endpoint provides session-based metrics including session count, average session duration, and bounce rate. The data can be aggregated by different time buckets and filtered by platform, device, and country.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&time_bucket=day&platform=web"
```

#### user_engagement_time_series

This endpoint delivers time series data for user engagement metrics, showing event counts, unique users, and average duration over time, with support for filtering by event type, platform, device, and country.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_engagement_time_series.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&time_bucket=hour&event_type=page_view"
```

#### geographic_distribution

This endpoint provides user engagement metrics segmented by geographic location, showing event counts, unique users, and average duration by country and region.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/geographic_distribution.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&event_type=page_view"
```

#### active_users

This endpoint delivers time series data for active users metrics, showing unique user counts over time with support for segmentation by platform and filtering by event type and country.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/active_users.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&time_bucket=hour"
```

#### event_metrics

This endpoint provides aggregated metrics by event type, showing event counts, unique users, and average duration for different types of user events, with support for filtering by platform and country.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```
