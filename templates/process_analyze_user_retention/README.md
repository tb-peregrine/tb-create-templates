
# User Retention Analysis API

This project provides an API to analyze user retention data through cohort analysis and various retention metrics.

## Tinybird

### Overview

This Tinybird project provides a comprehensive set of tools for analyzing user retention data. It enables cohort analysis, retention heatmaps, daily active user tracking, retention curves, and platform comparisons, helping businesses understand how users engage with their services over time.

### Data sources

#### user_retention_events

This datasource stores user retention events with details like user_id, event date, first seen date, event type, platform, country, and session ID. It's designed to track user engagement over time to measure retention.

To ingest data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_retention_events" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "user_id": "u123456",
      "event_date": "2023-06-15 14:30:00",
      "first_seen_date": "2023-05-01 09:15:00",
      "event_type": "login",
      "platform": "web",
      "country": "US",
      "session_id": "sess_abc123"
    }'
```

### Endpoints

#### cohort_analysis

Computes cohort analysis metrics based on user's first seen date and subsequent activity, showing user retention by week.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/cohort_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&platform=web"
```

#### cohort_retention_heatmap

Generates retention data in a format suitable for visualizing as a heatmap, showing user retention by month.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/cohort_retention_heatmap.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&platform=web"
```

#### daily_active_users

Computes daily active users count with options to filter by country, platform, and event type.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/daily_active_users.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&platform=web&event_type=login"
```

#### user_retention_curve

Generates a retention curve showing how user retention changes over time after first seen date.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_retention_curve.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&platform=web&max_days=90"
```

#### platform_retention_comparison

Compares retention rates between different platforms to identify which platform has better user engagement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/platform_retention_comparison.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&country=US&retention_days=30"
```
