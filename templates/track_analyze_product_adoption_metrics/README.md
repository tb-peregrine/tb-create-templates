# Product Adoption Analytics API

This project provides an API for tracking and analyzing product adoption metrics, including user behavior, feature usage, retention, and growth rates.

## Tinybird

### Overview

This Tinybird project creates a comprehensive analytics system for tracking product adoption metrics. It allows teams to monitor user engagement, analyze feature usage, measure retention rates, and track growth over time across different product segments.

### Data sources

#### product_adoptions

This datasource stores product adoption events including user's actions, timestamps, and product information. It tracks various metrics such as feature usage, session duration, device type, and geographic information.

To ingest data:

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=product_adoptions" \
    -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
    -d '{
      "user_id": "u123456", 
      "product_id": "prod-analytics", 
      "action": "first_use", 
      "timestamp": "2023-06-15 14:30:00", 
      "feature_used": "dashboard", 
      "session_duration": 300, 
      "device_type": "desktop", 
      "version": "1.2.0", 
      "country": "US", 
      "referrer": "google"
    }'
```

### Endpoints

#### adoption_by_segment

Analyzes product adoption segmented by different dimensions (country, device type, etc.) to understand how product usage varies across segments.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/adoption_by_segment.json?token=$TB_ADMIN_TOKEN&segment_by=device_type&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-analytics"
```

#### feature_adoption_analysis

Analyzes which features are most adopted by users to identify popular features and usage patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/feature_adoption_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-analytics"
```

#### user_retention_analysis

Analyzes user retention over time periods, showing how many users continue to use the product after their initial engagement.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_retention_analysis.json?token=$TB_ADMIN_TOKEN&product_id=prod-analytics&max_months=6"
```

#### growth_rate_analysis

Analyzes growth rates of product adoption over time, showing daily active users and percentage change.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/growth_rate_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-analytics"
```

#### product_adoption_metrics

Retrieves detailed product adoption metrics with filters for date range, product, and action.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/product_adoption_metrics.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&product_id=prod-analytics&action=first_use&country=US"
```
