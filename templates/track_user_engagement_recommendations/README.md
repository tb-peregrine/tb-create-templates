
# User Engagement Tracking API

This project is a comprehensive API to track and analyze user engagement with content and recommendations.

## Tinybird

### Overview

This Tinybird project provides a robust set of endpoints to track and analyze user interactions with content and recommendations. The API enables deep insights into user behavior, content performance, and recommendation effectiveness, helping to optimize engagement and personalization strategies.

### Data sources

#### user_events

Tracks user interactions with content and recommendations. This datasource stores all user events including views, clicks, shares, and likes along with contextual information like device, platform, and session data.

Example of how to ingest data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "e12345",
       "user_id": "u789",
       "event_type": "click",
       "content_id": "c456",
       "recommendation_id": "r123",
       "timestamp": "2023-05-15 14:30:00",
       "session_id": "sess789",
       "device": "mobile",
       "platform": "ios",
       "duration": 45,
       "metadata": "{\"source\":\"homepage\"}"
     }'
```

### Endpoints

#### user_content_affinity

Analyzes user affinity to different types of content by calculating an affinity score based on various interaction metrics.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_content_affinity.json?token=$TB_ADMIN_TOKEN&user_id=u789&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### recommendation_performance

Evaluates overall recommendation performance by tracking metrics like CTR and engagement rates across different recommendation algorithms.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/recommendation_performance.json?token=$TB_ADMIN_TOKEN&platform=ios&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### session_analysis

Analyzes user sessions and engagement patterns, providing insights into session duration, content diversity, and interaction depth.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_analysis.json?token=$TB_ADMIN_TOKEN&platform=android&device=mobile&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### content_engagement

Retrieves detailed content engagement metrics, helping to identify top-performing content and analyze performance by event type.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/content_engagement.json?token=$TB_ADMIN_TOKEN&content_id=c456&event_type=view&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### user_recommendations

Tracks recommendation effectiveness by user, providing insights into how individual users interact with specific recommendations.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_recommendations.json?token=$TB_ADMIN_TOKEN&user_id=u789&recommendation_id=r123&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```
