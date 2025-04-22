# Marketing Campaign Attribution Analytics

This project provides a comprehensive analytics solution for marketing campaign attribution, allowing you to track user journeys, analyze campaign performance, and apply different attribution models to understand your marketing ROI.

## Tinybird

### Overview

This Tinybird project enables you to track and analyze marketing campaign attribution across multiple channels. It provides tools to measure campaign performance, understand user journeys, analyze geographic distribution, and apply various attribution models to determine the effectiveness of your marketing efforts.

### Data Sources

#### Conversions

Stores conversion events data capturing successful conversions like purchases or sign-ups.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=conversions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "conversion_id": "conv_123",
       "user_id": "user_456",
       "conversion_type": "purchase",
       "conversion_value": 99.99,
       "timestamp": "2023-06-15 14:30:00",
       "campaign_id": "camp_789",
       "channel": "email"
     }'
```

#### Marketing Events

Stores raw marketing events data including user interactions with campaigns.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=marketing_events" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "event_id": "evt_123",
       "user_id": "user_456",
       "campaign_id": "camp_789",
       "channel": "email",
       "action": "click",
       "timestamp": "2023-06-15 14:25:00",
       "utm_source": "newsletter",
       "utm_medium": "email",
       "utm_campaign": "summer_sale",
       "device_type": "mobile",
       "country": "US",
       "referrer": "email_client",
       "conversion_value": 0
     }'
```

#### Campaigns

Stores marketing campaign metadata with details about each campaign.

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=campaigns" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "campaign_id": "camp_789",
       "campaign_name": "Summer Sale 2023",
       "start_date": "2023-06-01 00:00:00",
       "end_date": "2023-07-31 23:59:59",
       "budget": 5000.00,
       "target_audience": "existing_customers",
       "channel": "email",
       "goal": "revenue"
     }'
```

### Endpoints

#### Attribution Models

Apply different attribution models (first touch, last touch, linear) to evaluate campaign effectiveness.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/attribution_models.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=50"
```

#### Geographic Performance

Analyze campaign performance by geographic location.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/geographic_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&campaign_id=camp_789&channel=email"
```

#### User Journey

Track the user journey through the marketing funnel.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/user_journey.json?token=$TB_ADMIN_TOKEN&user_id=user_456&campaign_id=camp_789&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&limit=10"
```

#### Channel Attribution

Analyze marketing channel attribution and effectiveness.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/channel_attribution.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=email"
```

#### Campaign ROI Trend

Analyze campaign ROI trends over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_roi_trend.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&campaign_id=camp_789"
```

#### Campaign Performance

Analyze campaign performance by aggregating metrics per campaign.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/campaign_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01%2000:00:00&end_date=2023-12-31%2023:59:59&channel=email"
```
