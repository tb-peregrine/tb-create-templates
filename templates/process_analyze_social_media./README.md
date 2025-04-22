# Social Media Analytics API

This project provides a real-time API for analyzing social media engagement data across different platforms.

## Tinybird

### Overview

This Tinybird project is designed to process and analyze social media engagement events data in real-time. It enables you to track engagement metrics across different platforms, analyze content performance, understand user behavior, and identify geographic trends to optimize your social media strategy.

### Data Sources

#### social_media_events

Raw social media engagement events data that captures user interactions with content across multiple platforms.

**Ingestion Example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=social_media_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
        "event_id": "ev_123456789", 
        "platform": "Instagram", 
        "user_id": "user_12345", 
        "content_id": "post_67890", 
        "event_type": "like", 
        "event_timestamp": "2023-06-15 14:30:00", 
        "engagement_value": 5, 
        "device_type": "mobile", 
        "country": "United States", 
        "referrer": "direct"
     }'
```

### Endpoints

#### content_performance

Analyzes the performance of individual content pieces across platforms, showing metrics like likes, shares, comments, and views.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/content_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=Instagram&limit=50"
```

Parameters:
- `start_date`: Filter events after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter events before this date (format: YYYY-MM-DD HH:MM:SS)
- `platform`: Filter by specific platform
- `limit`: Number of results to return (default: 100)

#### engagement_by_platform

Provides engagement metrics grouped by platform and event type, showing counts and engagement values.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/engagement_by_platform.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=Twitter"
```

Parameters:
- `start_date`: Filter events after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter events before this date (format: YYYY-MM-DD HH:MM:SS)
- `platform`: Filter by specific platform

#### time_series_analysis

Analyzes engagement trends over time, with flexible time granularity options.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/time_series_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=Facebook&time_granularity=hour"
```

Parameters:
- `start_date`: Filter events after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter events before this date (format: YYYY-MM-DD HH:MM:SS)
- `platform`: Filter by specific platform
- `time_granularity`: Time grouping level (hour, day, month)

#### geographic_analysis

Analyzes engagement patterns by geographic location, showing regional differences in platform usage and engagement metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/geographic_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=YouTube&country=Germany"
```

Parameters:
- `start_date`: Filter events after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter events before this date (format: YYYY-MM-DD HH:MM:SS)
- `platform`: Filter by specific platform
- `country`: Filter by specific country

#### user_engagement

Analyzes individual user engagement patterns, showing activity metrics for specific users or top users by engagement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_engagement.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&platform=TikTok&user_id=user_54321&limit=20"
```

Parameters:
- `start_date`: Filter events after this date (format: YYYY-MM-DD HH:MM:SS)
- `end_date`: Filter events before this date (format: YYYY-MM-DD HH:MM:SS)
- `platform`: Filter by specific platform
- `user_id`: Filter for a specific user
- `limit`: Number of results to return (default: 100)
