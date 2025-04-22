
# User Behavior Analysis with Clustering

This project demonstrates how to build an API for processing and analyzing user behavior patterns with clustering.

## Tinybird

### Overview

This Tinybird project enables collection and analysis of user behavior data, including session tracking, event logging, and user clustering. The API provides endpoints for aggregating user features, analyzing session timelines, and categorizing users into behavioral clusters.

### Data sources

#### user_events

This datasource stores raw user behavior events data, including page visits, clicks, and session information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
        "user_id": "u123456",
        "event_type": "page_view",
        "timestamp": "2023-05-15 14:30:00",
        "session_id": "sess_abc123",
        "page": "/products",
        "referrer": "https://google.com",
        "device_type": "mobile",
        "country": "US",
        "duration": 45.5,
        "clicks": 3
     }'
```

#### user_features

This datasource contains aggregated user features derived from event data, used for clustering and analysis.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_features" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
        "user_id": "u123456",
        "avg_session_duration": 125.7,
        "total_sessions": 15,
        "avg_clicks_per_session": 8.3,
        "most_visited_page": "/products",
        "most_used_device": "mobile",
        "country": "US",
        "last_updated": "2023-05-20 16:45:00",
        "cluster_id": 1
     }'
```

### Endpoints

#### aggregate_user_features

This endpoint calculates aggregated metrics for each user from their event data, which can be used for clustering.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/aggregate_user_features.json?token=$TB_ADMIN_TOKEN"
```

#### user_session_timeline

This endpoint retrieves session timeline data for a specific user, optionally filtered by date range.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_session_timeline.json?token=$TB_ADMIN_TOKEN&user_id=u123456&from_date=2023-01-01%2000:00:00&to_date=2023-12-31%2023:59:59&limit=10"
```

#### get_user_patterns

This endpoint provides user behavior patterns with clustering information, allowing filtering by cluster, country, or session count.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_user_patterns.json?token=$TB_ADMIN_TOKEN&cluster_id=1&country=US&min_sessions=5&limit=50"
```

#### get_cluster_stats

This endpoint returns statistics for each user cluster, optionally filtered by cluster ID or minimum user count.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_cluster_stats.json?token=$TB_ADMIN_TOKEN&cluster_id=1&min_users=10"
```

#### assign_clusters

This endpoint manually assigns users to clusters based on their behavior patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/assign_clusters.json?token=$TB_ADMIN_TOKEN&country=US"
```
