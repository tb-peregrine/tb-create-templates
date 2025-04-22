
# User Acquisition Analytics API

This project provides an API to track and analyze user acquisition metrics across different channels, with detailed breakdowns by device, geography, UTM parameters, and more.

## Tinybird

### Overview

This Tinybird project is designed to help analyze user acquisition data, tracking how users sign up for your product across different marketing channels. It provides endpoints for understanding conversion rates, cohort analysis, device usage patterns, geographic distribution, and UTM attribution details.

### Data sources

#### user_acquisitions

This datasource stores raw user acquisition data, capturing user signups with attribution information including acquisition channel, campaign details, device type, geographic information, and UTM parameters.

**Sample ingestion:**

```bash
curl -X POST "https://api.europe-west2.gcp.tinybird.co/v0/events?name=user_acquisitions" \
     -H "Authorization: Bearer $TB_ADMIN_TOKEN" \
     -d '{
       "user_id": "u-12345",
       "signup_timestamp": "2023-03-15 14:30:00",
       "acquisition_channel": "organic_search",
       "campaign": "spring_promotion",
       "device_type": "mobile",
       "country": "US",
       "referrer": "google.com",
       "utm_source": "google",
       "utm_medium": "cpc",
       "utm_campaign": "brand_awareness",
       "conversion": 1
     }'
```

### Endpoints

#### acquisition_overview

Get an overview of user acquisition metrics with breakdowns by channel, including total users, conversion rates, and acquisition date ranges.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/acquisition_overview.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59&channel=organic_search"
```

#### daily_acquisitions

Daily breakdown of user acquisitions with channel analysis showing new users and conversion rates per day.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/daily_acquisitions.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```

#### cohort_analysis

Analyze user acquisition by weekly cohorts to track conversion rates over time.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/cohort_analysis.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```

#### device_analysis

Analyze user acquisition patterns by device type, showing which devices drive the highest conversions across different channels.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/device_analysis.json?token=$TB_ADMIN_TOKEN&channel=social_media"
```

#### utm_source_analysis

Detailed analysis of user acquisition by UTM source, medium, and campaign to track marketing campaign effectiveness.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/utm_source_analysis.json?token=$TB_ADMIN_TOKEN&source=google"
```

#### geographic_analysis

Analyze user acquisition by country to understand geographic distribution and regional conversion rates.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/geographic_analysis.json?token=$TB_ADMIN_TOKEN"
```

#### channel_performance

Compare performance metrics across acquisition channels and campaigns to identify top-performing strategies.

```bash
curl -X GET "https://api.europe-west2.gcp.tinybird.co/v0/pipes/channel_performance.json?token=$TB_ADMIN_TOKEN&start_date=2023-01-01 00:00:00&end_date=2023-12-31 23:59:59"
```
