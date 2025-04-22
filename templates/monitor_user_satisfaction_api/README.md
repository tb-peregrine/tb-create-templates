# User Satisfaction Monitoring API

This project provides a robust API for monitoring and analyzing user feedback and satisfaction metrics across different products, categories, and platforms.

## Tinybird

### Overview

The User Satisfaction Monitoring API is designed to collect, process, and analyze user feedback data to provide real-time insights into customer satisfaction metrics. It supports tracking ratings, comments, sentiment analysis, and categorized feedback across different products and platforms.

### Data Sources

#### user_feedback

Raw user feedback data including ratings, comments, and metadata.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_feedback" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "feedback_id": "f12345",
           "user_id": "u789",
           "product_id": "p456",
           "rating": 4,
           "comment": "Great product, works as expected!",
           "sentiment_score": 0.8,
           "category": "electronics",
           "platform": "mobile",
           "created_at": "2023-07-15 14:30:00",
           "tags": ["feature_request", "positive"]
         }'
```

#### feedback_metrics_daily

Daily aggregated feedback metrics for faster querying.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=feedback_metrics_daily" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
           "date": "2023-07-15",
           "product_id": "p456",
           "category": "electronics",
           "platform": "mobile",
           "feedback_count": 120,
           "avg_rating": 4.2,
           "avg_sentiment": 0.65,
           "satisfaction_rate": 0.85,
           "positive_count": 95,
           "neutral_count": 20,
           "negative_count": 5
         }'
```

### Endpoints

#### negative_feedback_alerts

Identifies negative feedback that might require immediate attention.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/negative_feedback_alerts.json?token=$TB_ADMIN_TOKEN&low_rating_threshold=2&low_sentiment_threshold=-0.5&product_id=p456&time_period_hours=24&limit=100"
```

#### feedback_analysis

Provides detailed analysis of user feedback with sentiment and category breakdown.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feedback_analysis.json?token=$TB_ADMIN_TOKEN&product_id=p456&min_rating=3&max_rating=5&min_date=2023-01-01%2000:00:00&max_date=2023-12-31%2023:59:59"
```

#### user_satisfaction_cohort

Analyzes user satisfaction trends across different user cohorts.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_satisfaction_cohort.json?token=$TB_ADMIN_TOKEN&product_id=p456&min_date=2023-01-01%2000:00:00&max_date=2023-12-31%2023:59:59&min_feedback_count=2&limit=100"
```

#### tag_performance_analysis

Analyzes feedback performance by the tags associated with feedback.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/tag_performance_analysis.json?token=$TB_ADMIN_TOKEN&product_id=p456&min_date=2023-01-01%2000:00:00&max_date=2023-12-31%2023:59:59&min_count=5&sort_by=rating&limit=50"
```

#### satisfaction_trends_dashboard

Provides satisfaction metrics and trends for dashboard visualization.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/satisfaction_trends_dashboard.json?token=$TB_ADMIN_TOKEN&product_id=p456&category=electronics&platform=mobile&min_date=2023-01-01%2000:00:00&max_date=2023-12-31%2023:59:59"
```

#### product_satisfaction_by_time

Analyzes product satisfaction metrics over time with flexible filtering.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_satisfaction_by_time.json?token=$TB_ADMIN_TOKEN&product_id=p456&category=electronics&platform=mobile&time_granularity=day&min_date=2023-01-01%2000:00:00&max_date=2023-12-31%2023:59:59"
```
