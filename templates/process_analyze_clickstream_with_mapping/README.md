# User Journey Mapping Analytics API

This project provides a comprehensive analytics API for analyzing user behavior and journey mapping from clickstream data.

## Tinybird

### Overview

This Tinybird project enables real-time analysis of user journeys from clickstream data. It provides a set of endpoints to analyze user behavior, conversion funnels, session metrics, page performance, user retention, and more. The project is designed to help understand how users navigate through a website or application.

### Data Sources

#### clickstream_events

This data source stores raw clickstream events containing user interaction data for journey mapping.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=clickstream_events" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "event_id": "ev-12345",
    "user_id": "user-789",
    "session_id": "sess-456",
    "timestamp": "2023-06-15 14:30:00",
    "event_type": "page_view",
    "page_url": "/products",
    "page_title": "Product Catalog",
    "referrer": "https://www.google.com",
    "device_type": "desktop",
    "browser": "Chrome",
    "os": "Windows",
    "country": "US",
    "user_agent": "Mozilla/5.0",
    "properties": "{\"scroll_depth\":75}"
  }'
```

#### user_journey_metrics

This data source stores aggregated metrics for user journeys to be used by materialized pipes.

```bash
# This is a materialized data source populated by the materialized_session_metrics pipe
# You don't need to ingest data directly into this data source
```

### Endpoints

#### funnel_analysis

Analyzes conversion funnel steps for a defined sequence of events.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/funnel_analysis.json?token=$TB_ADMIN_TOKEN&step_1_event=page_view&step_2_event=add_to_cart&step_3_event=checkout&step_4_event=purchase&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```

#### get_user_journey

Retrieves full user journey for a specific user or session.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_user_journey.json?token=$TB_ADMIN_TOKEN&user_id=user-789&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```

#### session_metrics

Retrieves session-level metrics like duration, page views, bounce rate, etc.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&country=US&device_type=mobile"
```

#### session_summary

Retrieves aggregated session metrics using the materialized data.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/session_summary.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01&end_date=2023-12-31"
```

#### page_performance

Analyzes page-level metrics like views, bounce rate, and conversion rate.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/page_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&limit=50"
```

#### popular_user_paths

Identifies the most common user paths through the website.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/popular_user_paths.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&min_path_length=2&max_path_length=5&limit=10"
```

#### user_retention

Analyzes user retention over time periods.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_retention.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```
