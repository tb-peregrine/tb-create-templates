# Feature Analytics API

This project provides a data analytics API for tracking and analyzing product feature usage, including adoption rates, user engagement, and usage patterns across different segments.

## Tinybird

### Overview

This Tinybird project is designed to track and analyze product feature usage. It enables you to monitor feature adoption rates, understand usage patterns across different user segments, and gain insights into how users interact with specific features over time.

### Data sources

#### users

Contains user information for feature usage analysis. This datasource stores user profiles, account information, and demographic data.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=users" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "u-123456", 
       "first_seen_at": "2023-01-01 10:00:00", 
       "last_seen_at": "2023-06-01 15:30:00", 
       "account_id": "acc-789", 
       "user_type": "admin", 
       "plan": "enterprise", 
       "country": "US", 
       "industry": "technology", 
       "team_size": 50
     }'
```

#### feature_events

Tracks individual feature usage events. This datasource collects detailed information about each interaction users have with features, including timing, duration, and status.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feature_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "timestamp": "2023-05-15 08:45:00", 
       "user_id": "u-123456", 
       "feature_id": "feat-001", 
       "feature_name": "Analytics Dashboard", 
       "session_id": "sess-abc123", 
       "action": "view", 
       "duration_seconds": 120.5, 
       "status": "success", 
       "details": "Viewed monthly report", 
       "platform": "web", 
       "version": "1.2.0"
     }'
```

### Endpoints

#### feature_usage_trend

Tracks usage trend of features over time by day or week. This endpoint helps visualize how feature usage evolves over time, allowing product teams to identify growing or declining feature adoption.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage_trend.json?token=$TB_ADMIN_TOKEN&start_date=2023-04-01%2000:00:00&end_date=2023-05-01%2000:00:00&interval=day&feature_id=feat-001"
```

#### segment_feature_usage

Compares feature usage across different user segments. This endpoint allows you to analyze how different user groups (by plan, country, industry, etc.) use specific features, helping identify patterns and optimization opportunities.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/segment_feature_usage.json?token=$TB_ADMIN_TOKEN&start_date=2023-04-01%2000:00:00&end_date=2023-05-01%2000:00:00&segment_by=industry&feature_id=feat-001"
```

#### user_feature_engagement

Analyzes individual user engagement with specific features. This endpoint provides detailed insights into how specific users interact with features, including usage frequency and patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_feature_engagement.json?token=$TB_ADMIN_TOKEN&start_date=2023-02-01%2000:00:00&end_date=2023-05-01%2000:00:00&feature_id=feat-001&user_id=u-123456"
```

#### feature_usage_summary

Summarizes feature usage over a selected time period. This endpoint provides aggregated metrics on feature usage, including total events, unique users, and success/error rates.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_usage_summary.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-05-01%2000:00:00&feature_id=feat-001"
```

#### feature_adoption_rate

Calculates feature adoption rate as percentage of active users. This endpoint helps product teams understand which features have the highest and lowest adoption rates among the active user base.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_adoption_rate.json?token=$TB_ADMIN_TOKEN&active_since=2023-04-01%2000:00:00&feature_id=feat-001"
```
