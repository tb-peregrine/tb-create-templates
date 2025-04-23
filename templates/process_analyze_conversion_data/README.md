# Marketing Analytics API

## Tinybird

### Overview
This Tinybird project provides a comprehensive API for tracking, analyzing, and optimizing marketing conversion data. It allows you to understand campaign performance, analyze user behavior, track UTM attribution, and make data-driven marketing decisions.

### Data Sources

#### user_conversion_events
Stores user conversion events from various marketing channels and campaigns. This datasource captures detailed information about conversions including revenue, device, location, and UTM parameters.

**Ingestion example:**
```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_conversion_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "ev-12345",
       "user_id": "user-789",
       "timestamp": "2023-06-15 14:30:00",
       "channel": "social",
       "campaign": "summer_promo",
       "conversion_type": "purchase",
       "revenue": 89.99,
       "device": "mobile",
       "country": "US",
       "utm_source": "instagram",
       "utm_medium": "cpc",
       "utm_campaign": "summer_sale",
       "utm_content": "carousel_ad",
       "utm_term": "discount"
     }'
```

### Endpoints

#### conversion_analysis
Analyze conversion data with filtering by date range, channel, and campaign. Provides metrics such as conversion count, revenue, and time span of conversions.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/conversion_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=social"
```

#### conversion_time_analysis
Analyze conversion trends over time with flexible time granularity (hour, day, week, month).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/conversion_time_analysis.json?token=$TB_ADMIN_TOKEN&granularity=day&start_date=2023-01-01%2000:00:00&end_date=2023-03-31%2023:59:59"
```

#### channel_performance
Compare performance metrics across different marketing channels, including events, unique users, revenue, and conversion rates.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/channel_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59"
```

#### campaign_optimization
Evaluate campaign performance to make optimization decisions. Provides metrics like event count, unique users, revenue, and conversion rate.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_optimization.json?token=$TB_ADMIN_TOKEN&channel=social&min_events=100"
```

#### utm_attribution_analysis
Analyze conversion attribution through UTM parameters to understand which sources and campaigns are driving results.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/utm_attribution_analysis.json?token=$TB_ADMIN_TOKEN&utm_source=instagram"
```

#### user_segmentation
Segment users based on their conversion behavior and value. Useful for identifying high-value customers and understanding user patterns.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_segmentation.json?token=$TB_ADMIN_TOKEN&min_conversions=2&sort_by=revenue&limit=50"
```
