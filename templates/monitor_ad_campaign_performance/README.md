
# Ad Campaign Analytics API

This project provides a comprehensive API for analyzing ad campaign performance, tracking user interactions, and measuring ROI across different platforms and segments.

## Tinybird

### Overview

This Tinybird project creates a real-time API for tracking and analyzing digital ad campaign performance. It enables marketers and analysts to monitor campaign effectiveness, user journey metrics, and ROI across different segments and platforms.

### Data sources

#### Ad Campaigns

Stores ad campaign metadata including campaign_id, name, budget, and start/end dates.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ad_campaigns" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "campaign_id": "c123",
    "name": "Summer Sale 2023",
    "budget": 5000.0,
    "start_date": "2023-06-01 00:00:00",
    "end_date": "2023-06-30 23:59:59",
    "status": "active",
    "platform": "facebook"
  }'
```

#### Ad Impressions

Tracks when ads are shown to users, capturing impression details and costs.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ad_impressions" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "impression_id": "imp123",
    "campaign_id": "c123",
    "ad_id": "ad456",
    "user_id": "u789",
    "timestamp": "2023-06-15 14:30:00",
    "platform": "facebook",
    "device": "mobile",
    "country": "US",
    "cost": 0.75
  }'
```

#### Ad Clicks

Records when users click on displayed ads, connecting impressions to potential conversions.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=ad_clicks" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "click_id": "click123",
    "impression_id": "imp123",
    "campaign_id": "c123",
    "ad_id": "ad456",
    "user_id": "u789",
    "timestamp": "2023-06-15 14:31:10",
    "platform": "facebook",
    "device": "mobile",
    "country": "US"
  }'
```

#### Conversions

Tracks when users complete desired actions after ad interactions, with associated revenue data.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=conversions" \
  -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
  -d '{
    "conversion_id": "conv123",
    "click_id": "click123",
    "campaign_id": "c123",
    "user_id": "u789",
    "conversion_type": "purchase",
    "revenue": 49.99,
    "timestamp": "2023-06-15 14:45:23",
    "platform": "facebook",
    "device": "mobile",
    "country": "US"
  }'
```

### Endpoints

#### Campaign Performance Summary

Provides a high-level overview of campaign performance with key metrics including impressions, clicks, conversions, and ROI data.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_performance_summary.json?token=$TB_ADMIN_TOKEN&campaign_id=c123&platform=facebook&status=active&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### Campaign Performance Over Time

Tracks campaign metrics over time for trend analysis, allowing you to see how performance changes throughout a campaign's duration.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_performance_over_time.json?token=$TB_ADMIN_TOKEN&campaign_id=c123&platform=facebook&start_date=2023-06-01&end_date=2023-06-30"
```

#### Segment Performance

Analyzes campaign performance across different segments like country, device, and platform to identify strongest performing audience segments.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/segment_performance.json?token=$TB_ADMIN_TOKEN&campaign_id=c123&segment_by=device&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### Campaign ROI Analysis

Performs detailed Return on Investment analysis for ad campaigns, including metrics like total spend, revenue, profit, and key cost metrics (CPM, CPC, CPA).

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_roi_analysis.json?token=$TB_ADMIN_TOKEN&campaign_id=c123&platform=facebook&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```

#### Conversion Attribution

Tracks the complete user journey from impression to click to conversion, with timing data to help understand the conversion funnel.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/conversion_attribution.json?token=$TB_ADMIN_TOKEN&campaign_id=c123&conversion_type=purchase&country=US&start_date=2023-06-01%2000:00:00&end_date=2023-06-30%2023:59:59"
```
