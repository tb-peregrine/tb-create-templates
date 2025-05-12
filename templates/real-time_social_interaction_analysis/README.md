# Social Media Interaction Analytics API

## Tinybird

### Overview
This project provides a real-time API for analyzing social media interactions across different platforms. It allows you to track trending content, analyze platform-specific engagement patterns, and monitor user activity. The API is designed to handle various types of social interactions such as posts, comments, likes, and shares.

### Data Sources

#### social_interactions
This datasource stores raw social media interactions including posts, comments, likes, and shares from various platforms with engagement metrics and timestamps.

**Example data ingestion:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=social_interactions" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "interaction_id": "int123456",
    "user_id": "user789",
    "interaction_type": "comment",
    "content_id": "post4567",
    "platform": "instagram",
    "timestamp": "2023-05-15 14:30:00",
    "text_content": "Great post about data analytics!",
    "engagement_count": 12,
    "tags": ["data", "analytics", "social"]
  }'
```

### Endpoints

#### trending_content
Identifies trending content based on recent engagement and interaction patterns across platforms. You can filter by platform and specify the time range to analyze.

**Example request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/trending_content.json?token=$TB_ADMIN_TOKEN&hours_back=48&min_interactions=15&platform_filter=twitter&limit=20"
```

Parameters:
- `hours_back`: Number of hours to look back (default: 24)
- `min_interactions`: Minimum interactions threshold (default: 10)
- `platform_filter`: Filter by platform (optional)
- `limit`: Maximum number of results to return (default: 50)

#### interactions_by_platform
Provides aggregated metrics on interactions grouped by platform and interaction type within a specified time range.

**Example request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/interactions_by_platform.json?token=$TB_ADMIN_TOKEN&start_date=2023-03-01%2000:00:00&end_date=2023-03-31%2023:59:59&platform_filter=facebook"
```

Parameters:
- `start_date`: Start date for analysis (format: YYYY-MM-DD HH:MM:SS, default: 2023-01-01 00:00:00)
- `end_date`: End date for analysis (format: YYYY-MM-DD HH:MM:SS, default: 2023-12-31 23:59:59)
- `platform_filter`: Filter by platform (optional)

#### user_activity_analysis
Analyzes user behavior by examining interaction patterns and engagement levels over time.

**Example request:**
```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_activity_analysis.json?token=$TB_ADMIN_TOKEN&since=2023-04-01%2000:00:00&min_engagement=10&limit=50"
```

Parameters:
- `since`: Start date for user activity analysis (format: YYYY-MM-DD HH:MM:SS, default: 2023-01-01 00:00:00)
- `min_engagement`: Minimum engagement threshold (optional, default: 5)
- `limit`: Maximum number of users to return (default: 100)
