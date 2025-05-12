
# Feature Usage Tracking API

Track and analyze feature usage across different product versions.

## Tinybird

### Overview

This project provides an API for tracking and analyzing feature usage across different product versions. It allows you to collect usage events and generate insights on feature adoption, user engagement, and version-specific usage patterns.

### Data sources

#### feature_events

This datasource stores events that track feature usage across product versions. Each record captures when a user interacts with a specific feature in a particular product version.

**Ingestion Example:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feature_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "evt_12345",
       "user_id": "usr_789",
       "feature_id": "feature_recommendations",
       "product_version": "2.4.1",
       "event_type": "feature_used",
       "timestamp": "2023-10-15 14:35:22",
       "session_id": "sess_456",
       "metadata": "{\"duration_seconds\":45,\"result\":\"success\"}"
     }'
```

### Endpoints

#### user_feature_usage

This endpoint provides feature usage details for a specific user, allowing you to analyze how individual users engage with different features across product versions.

**Example Usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_feature_usage.json?token=$TB_ADMIN_TOKEN&user_id=usr_789&feature_id=feature_recommendations" 
```

Parameters:
- `user_id` (required): The ID of the user to analyze
- `feature_id` (optional): Filter by specific feature
- `product_version` (optional): Filter by specific product version

#### feature_usage_summary

This endpoint provides a summary of feature usage by feature_id and product_version, showing overall adoption metrics.

**Example Usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage_summary.json?token=$TB_ADMIN_TOKEN&start_date=2023-09-01%2000:00:00&end_date=2023-10-31%2023:59:59" 
```

Parameters:
- `feature_id` (optional): Filter by specific feature
- `product_version` (optional): Filter by specific product version
- `start_date` (optional): Start date for analysis (format: YYYY-MM-DD HH:MM:SS)
- `end_date` (optional): End date for analysis (format: YYYY-MM-DD HH:MM:SS)

#### feature_usage_timeline

This endpoint provides a timeline of feature usage across time periods, enabling trend analysis.

**Example Usage:**

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage_timeline.json?token=$TB_ADMIN_TOKEN&feature_id=feature_recommendations&interval=7%20day" 
```

Parameters:
- `feature_id` (optional): Filter by specific feature
- `product_version` (optional): Filter by specific product version
- `interval` (optional): Time window for analysis (e.g., '7 day', '30 day')
