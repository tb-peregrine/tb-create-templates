# Real-time User Search Behavior Analysis with Tinybird

This project provides a real-time API for analyzing user search behavior, allowing you to gain insights into search trends, user activity, and overall search performance.

## Tinybird

### Overview

This Tinybird project focuses on providing real-time insights into user search behavior. It includes a data source for search events and several endpoints to analyze search metrics, trends, and user-specific activity.

### Data sources

#### search_events

This data source stores records of user search events, including search queries, timestamps, user identifiers, and other relevant information.

**Schema:**

```
`user_id` String `json:$.user_id`,
`session_id` String `json:$.session_id`,
`timestamp` DateTime `json:$.timestamp`,
`query` String `json:$.query`,
`results_count` Int32 `json:$.results_count`,
`clicked_result` UInt8 `json:$.clicked_result`,
`device_type` String `json:$.device_type`,
`country` String `json:$.country`
```

**Ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=search_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{"user_id":"user123", "session_id":"session456", "timestamp":"2024-01-26 10:00:00", "query":"example query", "results_count":10, "clicked_result":1, "device_type":"mobile", "country":"US"}'
```

### Endpoints

#### search_metrics

This endpoint returns key search metrics, grouped by a specified time period and optional dimensions like country or device type.  It allows for analysis of search volume, click-through rates, and user engagement over time.

**Usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/search_metrics.json?token=$TB_ADMIN_TOKEN&time_bucket=day&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59"
```

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/search_metrics.json?token=$TB_ADMIN_TOKEN&time_bucket=month&start_date=2024-01-01 00:00:00&end_date=2024-03-31 23:59:59&group_by=country"
```

#### search_trends

This endpoint returns the most popular search queries within a specified time range, optionally filtered by country.  It helps identify trending topics and understand user interests.

**Usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/search_trends.json?token=$TB_ADMIN_TOKEN&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59&limit=10"
```

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/search_trends.json?token=$TB_ADMIN_TOKEN&start_date=2024-01-01 00:00:00&end_date=2024-01-31 23:59:59&country=US&limit=5"
```

#### user_search_activity

This endpoint returns search activity statistics for a specific user or session. It provides insights into individual user behavior, including search frequency, click-through rates, and common search queries.

**Usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_search_activity.json?token=$TB_ADMIN_TOKEN&user_id=user123"
```

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_search_activity.json?token=$TB_ADMIN_TOKEN&session_id=session456&start_date=2024-01-01 00:00:00&end_date=2024-01-15 23:59:59"
```
