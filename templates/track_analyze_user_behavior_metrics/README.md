# User Behavior Analysis API

A powerful API for tracking, analyzing, and segmenting user behavior metrics to derive actionable insights.

## Tinybird

### Overview

This project provides a comprehensive solution for user behavior analysis with advanced segmentation capabilities. It allows tracking user events, creating and managing user segments, and analyzing behavior patterns through various metrics including retention, funnels, and event frequencies.

### Data sources

#### user_segments

Stores user segmentation information, allowing you to categorize users into different groups for targeted analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_segments" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "u12345",
       "segment_id": "seg-001",
       "segment_name": "High Value Customers",
       "created_at": "2023-05-15 08:30:00",
       "updated_at": "2023-05-15 08:30:00",
       "active": 1
     }'
```

#### user_events

Captures all user interactions for detailed behavior analysis, including event types, session information, and device/location data.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "ev12345",
       "user_id": "u12345",
       "event_type": "page_view",
       "timestamp": "2023-05-15 09:45:23",
       "session_id": "sess-abc123",
       "page": "/products",
       "referrer": "https://google.com",
       "device": "mobile",
       "os": "iOS",
       "browser": "Safari",
       "country": "US",
       "city": "San Francisco",
       "properties": "{\"product_id\":\"p789\",\"category\":\"electronics\"}"
     }'
```

#### metric_aggregations

Stores pre-aggregated metrics for fast retrieval across different segments and time periods.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=metric_aggregations" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "segment_id": "seg-001",
       "segment_name": "High Value Customers",
       "metric_name": "avg_session_duration",
       "metric_value": 325.5,
       "time_period": "2023-05-15 00:00:00",
       "granularity": "daily",
       "updated_at": "2023-05-16 01:15:00"
     }'
```

### Endpoints

#### user_retention_analysis

Analyzes user retention over time periods for different segments, allowing you to understand how well you're retaining users from each cohort.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_retention_analysis.json?token=$TB_ADMIN_TOKEN&segment_id=seg-001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&max_weeks=8"
```

#### segment_comparison

Compares multiple segments across key metrics to understand behavioral differences between user groups.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/segment_comparison.json?token=$TB_ADMIN_TOKEN&segment_ids=seg-001,seg-002,seg-003&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### event_funnel_analysis

Analyzes conversion rates through defined event funnels across user segments, helping identify drop-off points in user journeys.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_funnel_analysis.json?token=$TB_ADMIN_TOKEN&event_steps=page_view,add_to_cart,checkout,purchase&segment_id=seg-001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### user_events_by_segment

Retrieves detailed user events filtered by segment and time range, providing raw event data for in-depth analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_events_by_segment.json?token=$TB_ADMIN_TOKEN&segment_id=seg-001&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&event_type=page_view&limit=1000"
```

#### create_user_segment

API to create a new user segment based on behavior criteria, allowing dynamic segmentation based on user behaviors.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/create_user_segment.json?token=$TB_ADMIN_TOKEN&segment_name=Power%20Users&event_type=purchase&min_event_count=5&country=US&time_period_days=30"
```

#### user_behavior_timeline

Generates a timeline of user behavior for individual user analysis, providing a chronological view of all user actions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_behavior_timeline.json?token=$TB_ADMIN_TOKEN&user_id=u12345&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=100"
```

#### event_frequency_by_segment

Analyzes event frequency across different user segments with time period breakdown, showing how often users perform specific actions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_frequency_by_segment.json?token=$TB_ADMIN_TOKEN&segment_id=seg-001&event_types=page_view,purchase&time_granularity=day&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```
