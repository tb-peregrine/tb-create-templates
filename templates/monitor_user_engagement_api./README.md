
# Feature Usage Analytics API

This project provides an API to track and analyze user engagement with features and usage patterns across platforms.

## Tinybird

### Overview

This Tinybird project provides a real-time API for monitoring and analyzing user engagement with features and platform usage patterns. It helps product teams understand how users interact with different features across platforms, identify popular features, track adoption rates, and gain insights into user sessions and engagement metrics.

### Data Sources

#### user_events

This data source tracks user interactions and events for feature usage analysis. It captures detailed information about each user action including the feature used, event type, and contextual information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "user_id": "u123456",
         "event_type": "click",
         "event_name": "button_press",
         "feature_id": "feature_123",
         "session_id": "sess_abc123",
         "timestamp": "2023-05-15 14:30:00",
         "platform": "web",
         "device_type": "desktop",
         "version": "1.2.3",
         "duration_ms": 150,
         "properties": "{\"button_color\":\"blue\",\"page\":\"homepage\"}"
     }'
```

#### user_sessions

This data source stores user session data for engagement analysis. It captures session-level metrics including duration, platform information, and event counts.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_sessions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
         "session_id": "sess_abc123",
         "user_id": "u123456",
         "start_time": "2023-05-15 14:00:00",
         "end_time": "2023-05-15 14:45:00",
         "duration_seconds": 2700,
         "platform": "web",
         "device_type": "desktop",
         "version": "1.2.3",
         "session_events_count": 25
     }'
```

### Endpoints

#### feature_usage_stats

This endpoint analyzes feature usage patterns across the platform. It provides metrics such as total usage count, unique users, and average duration per feature.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage_stats.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&feature_id=feature_123"
```

Parameters:
- `start_date`: DateTime (optional, default: '2023-01-01 00:00:00')
- `end_date`: DateTime (optional, default: '2023-12-31 23:59:59')
- `feature_id`: String (optional)
- `event_name`: String (optional)

#### platform_usage_breakdown

This endpoint analyzes usage patterns across different platforms and devices. It helps identify which platforms and device types are most popular among users.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/platform_usage_breakdown.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=web"
```

Parameters:
- `start_date`: DateTime (optional, default: '2023-01-01 00:00:00')
- `end_date`: DateTime (optional, default: '2023-12-31 23:59:59')
- `platform`: String (optional)
- `device_type`: String (optional)

#### user_feature_adoption

This endpoint tracks feature adoption rates among users over time. It calculates the percentage of active users using each feature.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_feature_adoption.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&time_granularity=month"
```

Parameters:
- `start_date`: DateTime (optional, default: '2023-01-01 00:00:00')
- `end_date`: DateTime (optional, default: '2023-12-31 23:59:59')
- `time_granularity`: String (optional, default: 'month')

#### user_engagement_metrics

This endpoint provides user engagement metrics with features over time. It helps track how individual users are engaging with the platform.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_engagement_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&time_granularity=day&user_id=u123456"
```

Parameters:
- `start_date`: DateTime (optional, default: '2023-01-01 00:00:00')
- `end_date`: DateTime (optional, default: '2023-12-31 23:59:59')
- `time_granularity`: String (optional, default: 'day')
- `user_id`: String (optional)

#### session_analysis

This endpoint analyzes user session data for engagement insights. It provides metrics on session duration, frequency, and events per session.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&time_granularity=day&platform=web"
```

Parameters:
- `start_date`: DateTime (optional, default: '2023-01-01 00:00:00')
- `end_date`: DateTime (optional, default: '2023-12-31 23:59:59')
- `time_granularity`: String (optional, default: 'day')
- `platform`: String (optional)
