
# Product Usage Analytics API

A Tinybird API for tracking and analyzing product usage metrics with feature adoption insights.

## Tinybird

### Overview
This project implements a comprehensive Product Usage Analytics system to track user engagement with product features. It provides APIs for analyzing feature performance, user adoption journeys, usage patterns, and device distribution to help product teams make data-driven decisions.

### Data Sources

#### user_events
Stores raw user events for product usage tracking. This data source captures all user interactions with the product features.

**Example Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "event_id": "evt_12345",
    "user_id": "usr_789",
    "event_type": "click",
    "feature_id": "feature_123",
    "timestamp": "2023-06-15 08:30:45",
    "device_type": "mobile",
    "os": "iOS",
    "browser": "Safari",
    "session_id": "sess_456",
    "metadata": "{\"button_id\":\"submit_btn\"}"
  }'
```

#### feature_metadata
Stores metadata about product features including their properties and release information.

**Example Ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feature_metadata" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "feature_id": "feature_123",
    "feature_name": "One-click Checkout",
    "category": "Payments",
    "release_date": "2023-05-01",
    "description": "Enables users to complete purchases with a single click",
    "is_beta": 0
  }'
```

### Endpoints

#### feature_performance_analytics
Analyzes feature performance with detailed metadata, including adoption rate and usage metrics.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_performance_analytics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&category=Payments"
```

#### user_adoption_journey
Tracks user adoption journey through features over time, showing which users are most engaged.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_adoption_journey.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### feature_usage_by_period
Analyzes feature usage metrics over a specific time period, with comparison to average usage.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage_by_period.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&feature_id=feature_123"
```

#### feature_adoption_rate
Calculates feature adoption rate over time, showing percentage of total users adopting each feature.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_adoption_rate.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### event_activity_over_time
Analyzes user activity patterns over time, showing daily event counts and unique users.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_activity_over_time.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&event_type=click"
```

#### device_platform_distribution
Analyzes product usage across different devices and platforms, showing which technologies your users prefer.

**Example Usage:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/device_platform_distribution.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```
