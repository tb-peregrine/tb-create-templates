# User Engagement Analytics API

This project provides API endpoints for analyzing user interactions and engagement on a website or application.

## Tinybird

### Overview

This Tinybird project provides a comprehensive analytics solution for tracking and analyzing user engagement and interactions. It enables you to monitor page performance, user flows, session quality, and engagement levels through a series of interconnected endpoints that analyze raw interaction data against predefined engagement thresholds.

### Data sources

#### user_interactions

Stores raw user interaction events data containing details about user actions and engagement.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_interactions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "evt_12345",
       "user_id": "user_789",
       "timestamp": "2023-05-15 14:30:00",
       "event_type": "page_view",
       "page": "/products",
       "session_id": "sess_456",
       "duration_seconds": 45.5,
       "engagement_score": 0.75,
       "device_type": "mobile",
       "browser": "Chrome",
       "country": "US",
       "referrer": "google.com"
     }'
```

#### engagement_thresholds

Stores defined engagement threshold values for classification and analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=engagement_thresholds" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "threshold_id": "th_123",
       "threshold_name": "high_engagement",
       "min_score": 0.7,
       "max_score": 1.0,
       "color_code": "#00FF00",
       "description": "Highly engaged users",
       "created_at": "2023-01-01 00:00:00",
       "updated_at": "2023-01-01 00:00:00"
     }'
```

### Endpoints

#### engagement_classification

Classifies users based on their average engagement scores using predefined thresholds.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/engagement_classification.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### page_performance

Analyzes performance metrics for different pages based on user interactions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/page_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&page=/products"
```

#### user_flow_analysis

Tracks how users navigate between pages to identify common paths and potential bottlenecks.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_flow_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&from_page=/home&to_page=/products&limit=20"
```

#### user_engagement_stats

Provides detailed engagement statistics for individual users.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_engagement_stats.json?token=$TB_ADMIN_TOKEN&user_id=user_123&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### event_type_analysis

Analyzes different types of events to understand which generate the most engagement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/event_type_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&event_type=click"
```

#### session_analysis

Provides detailed insights into individual user sessions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_analysis.json?token=$TB_ADMIN_TOKEN&session_id=sess_456&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### time_series_analysis

Analyzes user engagement patterns over time to identify trends and peak usage periods.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/time_series_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-01-07%2023:59:59&event_type=page_view"
```

#### geographic_analysis

Analyzes user engagement patterns by country.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/geographic_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US"
```

#### referrer_analysis

Evaluates the effectiveness of different traffic sources based on user engagement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/referrer_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&referrer=google.com"
```
