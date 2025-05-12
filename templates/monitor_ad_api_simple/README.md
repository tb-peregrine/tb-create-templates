# Real-time Ad Performance Monitoring API

## Tinybird

### Overview
This project provides a real-time ad performance monitoring API built with Tinybird. It tracks ad impressions and clicks, allowing advertisers to monitor campaign performance, analyze click-through rates, and optimize their ad strategy through real-time dashboards and analytics.

### Data Sources

#### ad_impressions
This data source tracks ad impressions in real-time, including information about the ad, campaign, platform, user, and timing.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ad_impressions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "impression_id": "imp-123456",
       "ad_id": "ad-789",
       "campaign_id": "camp-456",
       "platform": "mobile",
       "timestamp": "2023-05-01 14:30:00",
       "user_id": "user-abc123",
       "country": "US",
       "device_type": "smartphone"
     }'
```

#### ad_clicks
This data source tracks ad clicks, connecting them to impressions for conversion tracking.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ad_clicks" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "click_id": "click-789123",
       "impression_id": "imp-123456",
       "ad_id": "ad-789",
       "campaign_id": "camp-456",
       "platform": "mobile",
       "timestamp": "2023-05-01 14:31:05",
       "user_id": "user-abc123",
       "country": "US",
       "device_type": "smartphone"
     }'
```

### Endpoints

#### campaign_performance_by_platform
This endpoint provides campaign performance metrics broken down by platform, allowing you to compare how your campaigns perform across different platforms.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_performance_by_platform.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&campaign_id=camp-456"
```

#### ad_performance_by_time
This endpoint shows ad performance metrics over time with configurable time granularity, allowing for trend analysis.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ad_performance_by_time.json?token=$TB_ADMIN_TOKEN&time_granularity=day&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&ad_id=ad-789"
```

#### ad_performance_overview
This endpoint provides a general overview of ad performance metrics across all ads or filtered by specific campaign or ad.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/ad_performance_overview.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=10"
```
