# Product Usage Analytics API

## Tinybird

### Overview

This project provides a complete analytics API for tracking and analyzing product usage patterns and trends. It enables you to monitor user engagement, feature adoption, retention, and session activity across your applications.

### Data sources

#### user_profiles

Contains user profile data with demographic and account information.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_profiles" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "user_id": "u12345",
    "sign_up_date": "2023-01-15 10:30:00",
    "user_type": "premium",
    "account_status": "active",
    "subscription_plan": "enterprise",
    "country": "USA",
    "organization_id": "org789",
    "organization_name": "Acme Corp",
    "last_login": "2023-06-20 15:45:00"
  }'
```

#### product_usage_events

Raw product usage events data containing user interactions.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=product_usage_events" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "event_id": "evt98765",
    "user_id": "u12345",
    "product_id": "prod456",
    "event_type": "feature_interaction",
    "event_timestamp": "2023-06-21 14:23:45",
    "device_type": "desktop",
    "platform": "web",
    "version": "2.1.0",
    "session_id": "sess1234",
    "duration_seconds": 120,
    "feature_used": "dashboard",
    "page_path": "/analytics/dashboard",
    "metadata": "{\"button_clicked\":\"export\",\"filters\":{\"date_range\":\"last_30_days\"}}"
  }'
```

### Endpoints

#### user_retention_analysis

Analyze user retention over different time periods.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_retention_analysis.json?token=$TB_ADMIN_TOKEN&product_id=prod456&start_date=2023-01-01%2000:00:00&end_date=2023-06-30%2023:59:59&max_days=60"
```

#### product_usage_stats

Get aggregate statistics about product usage across different dimensions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_usage_stats.json?token=$TB_ADMIN_TOKEN&group_by=platform&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod456&event_type=feature_interaction"
```

#### feature_usage_trends

Analyze feature usage trends over time with flexible time granularity.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage_trends.json?token=$TB_ADMIN_TOKEN&time_granularity=day&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod456"
```

#### get_user_activity

Retrieve user activity data with filtering capabilities.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/get_user_activity.json?token=$TB_ADMIN_TOKEN&user_id=u12345&product_id=prod456&event_type=feature_interaction&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=100"
```

#### user_session_analysis

Analyze user session patterns and engagement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_session_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod456&user_id=u12345&sort_by=duration&limit=50"
```

#### user_engagement_scoring

Calculate engagement scores for users based on their activity patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_engagement_scoring.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod456&sort_by=score&limit=100"
```

#### feature_adoption_funnel

Analyze the feature adoption funnel to understand user progression through product workflows.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_adoption_funnel.json?token=$TB_ADMIN_TOKEN&product_id=prod456&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&feature_sequence=login,dashboard,profile,settings"
```
