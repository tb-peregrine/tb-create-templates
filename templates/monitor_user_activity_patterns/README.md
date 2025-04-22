
# User Behavior Analytics Platform

This project provides a behavioral analytics platform for monitoring and analyzing user activity patterns.

## Tinybird

### Overview
This Tinybird project is designed to analyze user behavior patterns, detect anomalies, and segment users based on their interactions. It provides endpoints for querying user activity, analyzing session metrics, and understanding user retention.

### Data sources

#### user_segments
Stores user segment classifications based on behavioral patterns.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_segments" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "user_id": "user_123",
         "segment_id": "segment_456",
         "segment_name": "power_users",
         "first_seen": "2023-01-15 10:30:00",
         "last_seen": "2023-06-20 15:45:00",
         "recency_days": 5,
         "frequency": 42,
         "avg_session_duration": 15.7,
         "preferred_device": "mobile",
         "top_country": "US",
         "engagement_score": 8.5,
         "last_updated": "2023-06-21 08:00:00"
     }'
```

#### user_activity_events
Stores user activity events for behavioral analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_activity_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "event_id": "evt_789",
         "user_id": "user_123",
         "session_id": "session_456",
         "event_type": "page_view",
         "event_name": "product_page",
         "page_url": "https://example.com/products/1",
         "referrer_url": "https://example.com/home",
         "timestamp": "2023-06-15 14:30:00",
         "user_agent": "Mozilla/5.0...",
         "ip_address": "192.168.1.1",
         "device_type": "desktop",
         "country": "US",
         "city": "New York",
         "properties": "{\"product_id\":\"123\",\"category\":\"electronics\"}"
     }'
```

### Endpoints

#### anomaly_detection
Detects anomalies in user behavior patterns by comparing recent activity against historical baselines.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/anomaly_detection.json?token=$TB_ADMIN_TOKEN&recent_days=3&z_score_threshold=2.5&limit=50"
```

#### get_user_segments
Retrieves user segments with filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_user_segments.json?token=$TB_ADMIN_TOKEN&user_id=user_123&min_engagement=5.0&limit=50"
```

#### user_retention_analysis
Analyzes user retention patterns over time by cohort.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_retention_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&max_weeks=8"
```

#### get_user_activity
Retrieves user activity events with filtering options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_user_activity.json?token=$TB_ADMIN_TOKEN&user_id=user_123&event_type=page_view&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&limit=100"
```

#### user_session_metrics
Analyzes user session metrics for behavioral patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_session_metrics.json?token=$TB_ADMIN_TOKEN&user_id=user_123&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### user_behavior_patterns
Identifies user behavior patterns by analyzing event sequences.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_behavior_patterns.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&limit=50"
```

#### event_frequency_analysis
Analyzes frequency of different event types for behavioral insights.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_frequency_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&limit=50"
```
